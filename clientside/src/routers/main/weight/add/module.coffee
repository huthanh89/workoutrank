#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'touchspin'
require 'backbone.stickit'
require 'bootstrap.datetimepicker'

#-------------------------------------------------------------------------------
# Model
#-------------------------------------------------------------------------------

class Model extends Backbone.Model

  url: '/api/wlogs'

  idAttribute: '_id'

  defaults:
    date:   moment()
    weight: null
    note:   ''

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:
    dialog: '.modal'
    weight: '#weight-modal-weight'
    submit: '#weight-modal-submit'
    date:   '#weight-modal-date'
    time:   '#weight-modal-time'

  bindings:
    '#weight-modal-timestamp':
      observe: 'date'
      onGet: (value) -> moment(value).format('YYYY/MM/DD - HH:mm:ss a')

    '#weight-modal-weight':
      observe: 'weight'
      onSet: (value) -> parseFloat(value)

    '#weight-modal-note': 'note'

  events:

    'click #weight-modal-exercise': ->
      @rootChannel.request('exercise')
      return

    'submit': (event) ->
      event.preventDefault()
      @rootChannel.request 'spin:page:loader', true
      @model.set
        date: @ui.date.data('DateTimePicker').date().format()

      @model.save {},
        success: (model) =>
          @rootChannel.request 'spin:page:loader', false
          @collection.add model.attributes
          @ui.dialog.modal('hide')
          return
        error: (model, response) =>
          @rootChannel.request 'message:error', response
          return

      return

    'hidden.bs.modal': ->
      @ui.weight.TouchSpin('destroy')
      @ui.date.data('DateTimePicker').destroy()
      @unstickit()
      return

  constructor: (options) ->
    super
    @rootChannel = Backbone.Radio.channel('root')
#    @model.set('date', new Date(options.date))
    @model.set('date', moment())

    # If there are data, use the latest data found in collection
    # as default values.

    if @collection.length
      latestModel = @collection.at(@collection.length - 1)
      @model.set 'weight', latestModel.get('weight')

    user = Backbone.Radio.channel('user').request 'user'

    if @model.get('body')
      @model.set('weight', user.get('weight'))

  onRender: ->

    date = @model.get('date')

    @ui.weight.TouchSpin
      postfix:          'pounds'
      buttondown_class: 'btn btn-info'
      buttonup_class:   'btn btn-info'
      min:               1
      max:               99999
      step:              0.1
      decimals:          1

    @ui.date.datetimepicker
      inline:      true
      sideBySide:  false
      minDate:     moment(date).subtract(1, 'years')
      maxDate:     moment(date).add(1, 'years')
      defaultDate: moment(date)

    @stickit()

    # Show this dialog

    @ui.dialog.modal()

    return

  onBeforeDestroy: ->
    $('.modal-backdrop').remove()
    $('body').removeClass 'modal-open'
    @unstickit()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Model = Model
module.exports.View  = View

#-------------------------------------------------------------------------------
