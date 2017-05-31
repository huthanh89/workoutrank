#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

$            = require 'jquery'
moment       = require 'moment'
Backbone     = require 'backbone'
Radio        = require 'backbone.radio'
Marionette   = require 'backbone.marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

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

  idAttribute: '_id'

  defaults:
    date: moment()
    name: ''
    note: ''

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.View

  template: viewTemplate

  ui:
    dialog:     '#cardio-modal-dialog'
    name:       '#cardio-modal-name'
    submit:     '#cardio-modal-submit'
    noteEnable: '#cardio-modal-note-enable'
    note:       '#cardio-modal-note'

  bindings:

    '#cardio-modal-name': 'name'

    '#cardio-modal-note': 'note'

  events:

    'shown.bs.modal': ->
      return

    'submit': (event) ->
      event.preventDefault()
      rootChannel.request 'spin:page:loader', true

      @collection.create @model.attributes,
        wait: true
        at:   0
        success: (model) =>
          rootChannel.request 'spin:page:loader', false
          @ui.dialog.modal('hide')

          # Finish, redirect to the actual cardio log.

          rootChannel.request 'cardio:detail', model.id
          return
        error: (model, response) ->
          rootChannel.request 'message:error', response
          return

      return

    'hidden.bs.modal': ->
      return

    'click #cardio-modal-note-enable': ->
      checked = @ui.noteEnable.is(':checked')
      if checked then @ui.note.removeClass('hide') else @ui.note.addClass('hide')
      return

  constructor: (options) ->
    super
    @mergeOptions options, [
      'edit'
    ]

  onRender: ->

    date = moment(@model.get('date'))

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
