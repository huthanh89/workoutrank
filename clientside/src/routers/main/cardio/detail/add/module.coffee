#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'backbone.marionette'
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
    intensity:  '#cardio-modal-intensity'
    speed:      '#cardio-modal-speed'

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

    '#cardio-modal-intensity':
      observe: 'intensity'
      onSet: (value) -> parseInt(value)

    '#cardio-modal-speed':
      observe: 'speed'
      onSet: (value) -> parseInt(value)

    '#cardio-modal-note': 'note'

  events:

    'click #cardio-modal-exercise': ->
      @rootChannel.request('exercise')
      return

    'submit': (event) ->

      event.preventDefault()

      @rootChannel.request 'spin:page:loader', true

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
      @ui.duration.TouchSpin('destroy')
      @ui.intensity.TouchSpin('destroy')
      @ui.speed.TouchSpin('destroy')
      @unstickit()
      return

    'click #cardio-modal-note-enable': ->
      checked = @ui.noteEnable.is(':checked')
      if checked then @ui.note.removeClass('hide') else @ui.note.addClass('hide')
      return

  constructor: (options) ->
    super
    @rootChannel = Backbone.Radio.channel('root')

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
      @model.set 'intensity', latestModel.get('intensity')
      @model.set 'speed',     latestModel.get('speed')

  onRender: ->

    @ui.duration.TouchSpin
      postfix:          'minutes'
      buttondown_class: 'btn btn-info'
      buttonup_class:   'btn btn-info'
      min:              0
      max:              9999

    @ui.intensity.TouchSpin
      buttondown_class: 'btn btn-info'
      buttonup_class:   'btn btn-info'
      min:              0
      max:              100
      step:             1

    @ui.speed.TouchSpin
      postfix:          'mph'
      buttondown_class: 'btn btn-info'
      buttonup_class:   'btn btn-info'
      min:              0
      max:              100
      step:             1

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
