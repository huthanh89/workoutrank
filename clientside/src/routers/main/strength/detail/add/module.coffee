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

  url: '/api/slogs'

  idAttribute: '_id'

  defaults:
    date:     moment()
    name:     ''
    exercise: ''
    rep:      null
    weight:   null
    muscle:   0
    note:     ''

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:
    dialog: '.modal'
    type:   '#strength-modal-type'
    rep:    '#strength-modal-rep'
    weight: '#strength-modal-weight'
    submit: '#strength-modal-submit'
    date:   '#strength-modal-date'
    time:   '#strength-modal-time'

  bindings:

    '#strength-modal-rep':
      observe: 'rep'
      onSet: (value) -> parseInt(value)

    '#strength-modal-weight':
      observe: 'weight'
      onSet: (value) -> parseInt(value)

    '#strength-modal-note': 'note'

  events:

    'shown.bs.modal': ->
      @ui.weight.focus()
      return

    'click #strength-modal-exercise': ->
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
      @ui.rep.TouchSpin('destroy')
      @ui.weight.TouchSpin('destroy')
      @ui.date.data('DateTimePicker').destroy()
      @unstickit()
      return

  constructor: (options) ->
    super
    @rootChannel = Backbone.Radio.channel('root')
    @model.set('date', new Date(options.date))

    # If there are data, use the latest data found in collection
    # as default values.

    if @collection.length
      latestModel = @collection.at(@collection.length - 1)
      @model.set 'rep', latestModel.get('rep')
      @model.set 'weight', latestModel.get('weight')

  onRender: ->

    date = @model.get('date')

    @ui.rep.TouchSpin
      buttondown_class: 'btn btn-info'
      buttonup_class:   'btn btn-info'
      min:              1
      max:              99999

    @ui.weight.TouchSpin
      buttondown_class: 'btn btn-info'
      buttonup_class:   'btn btn-info'
      min:              1
      max:              99999

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

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Model = Model
module.exports.View  = View

#-------------------------------------------------------------------------------
