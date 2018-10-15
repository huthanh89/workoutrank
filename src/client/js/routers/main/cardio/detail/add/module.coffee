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

#-------------------------------------------------------------------------------
# Model
#-------------------------------------------------------------------------------

class Model extends Backbone.Model

  url: '/api/clogs'

  idAttribute: '_id'

  defaults:
    date:       moment()
    exerciseID: ''
    duration:   null
    intensity:  null
    speed:      null
    note:       ''

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.View

  template: viewTemplate

  ui:
    dialog:     '.modal'
    submit:     '#cardio-modal-submit'
    date:       '#cardio-modal-date'
    time:       '#cardio-modal-time'
    noteEnable: '#cardio-modal-note-enable'
    note:       '#cardio-modal-note'
    duration:   '#cardio-modal-duration'

  bindings:

    '#cardio-modal-timestamp-date':
      observe: 'date'
      onGet: (value) -> moment(value).format('MMMM DD, YYYY')

    '#cardio-modal-timestamp-time':
      observe: 'date'
      onGet: (value) -> moment(value).format('hh:mm a')

    '#cardio-modal-duration':
      observe: 'duration'
      onSet: (value) -> parseInt(value)

    '#cardio-modal-note': 'note'

  events:

    'click #cardio-modal-exercise': ->
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
      @ui.duration.TouchSpin('destroy')
      @unstickit()
      return

    'click #cardio-modal-note-enable': ->
      checked = @ui.noteEnable.is(':checked')
      if checked then @ui.note.removeClass('hide') else @ui.note.addClass('hide')
      return

  constructor: (options) ->
    super

    @mergeOptions options, [
      'cLogs'
    ]

    if options.date
      @model.set('date', options.date)

    # If there are data, use the latest data found in collection
    # as default values.

    if @collection.length
      latestModel = @collection.at(@collection.length - 1)
      @model.set 'duration',  latestModel.get('duration')

  onRender: ->

    @ui.duration.TouchSpin
      postfix:          'minute'
      buttondown_class: 'btn btn-info'
      buttonup_class:   'btn btn-info'
      min:              0
      max:              9999

    @stickit()

    # Show this dialog

    @ui.dialog.modal()

    return

  onBeforeDestroy: ->
    $('.modal-backdrop').remove()
    $('body').removeClass 'modal-open'
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Model = Model
module.exports.View  = View

#-------------------------------------------------------------------------------
