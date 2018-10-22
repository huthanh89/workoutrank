#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
Backbone     = require 'backbone'
Radio        = require 'backbone.radio'
Marionette   = require 'backbone.marionette'
viewTemplate = require './view.pug'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'touchspin'
require 'backbone.stickit'
require 'bootstrap.datetimepicker'

#-------------------------------------------------------------------------------
# Channels
#-------------------------------------------------------------------------------

rootChannel = Radio.channel('root')
userChannel = Radio.channel('user')

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

class View extends Marionette.View

  template: viewTemplate

  ui:
    dialog:     '.modal'
    weight:     '#weight-modal-weight'
    submit:     '#weight-modal-submit'
    date:       '#weight-modal-date'
    time:       '#weight-modal-time'
    noteEnable: '#weight-modal-note-enable'
    note:       '#weight-modal-note'

  bindings:
    '#weight-modal-timestamp':
      observe: 'date'
      onGet: (value) -> moment(value).format('MMMM DD, YYYY - HH:mm a')

    '#weight-modal-weight':
      observe: 'weight'
      onSet: (value) -> parseFloat(value)

    '#weight-modal-note': 'note'

  events:

    'click #weight-modal-exercise': ->
      rootChannel.request('exercise')
      return

    'submit': (event) ->
      event.preventDefault()
      rootChannel.request 'spin:page:loader', true

      @model.save {},
        success: (model) =>
          rootChannel.request 'spin:page:loader', false
          @collection.add model.attributes
          @ui.dialog.modal('hide')
          return
        error: (model, response) ->
          rootChannel.request 'message:error', response
          return

      return

    'hidden.bs.modal': ->
      @ui.weight.TouchSpin('destroy')
      @unstickit()
      return

    'click #weight-modal-note-enable': ->
      checked = @ui.noteEnable.is(':checked')
      if checked then @ui.note.removeClass('hide') else @ui.note.addClass('hide')
      return

  constructor: (options) ->
    super(options)
    @model.set('date', moment())

    # If there are data, use the latest data found in collection
    # as default values.

    if @collection.length
      latestModel = @collection.at(@collection.length - 1)
      @model.set 'weight', latestModel.get('weight')

    user = userChannel.request 'user'

    if @model.get('body')
      @model.set('weight', user.get('weight'))

  onRender: ->

    console.log 'ernder'

    date = @model.get('date')

    @ui.weight.TouchSpin
      postfix:          'pounds'
      buttondown_class: 'btn btn-info'
      buttonup_class:   'btn btn-info'
      min:               1
      max:               99999
      step:              0.1
      decimals:          1

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
