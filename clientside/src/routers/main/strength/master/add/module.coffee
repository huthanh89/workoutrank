#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

$            = require 'jquery'
moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'backbone.marionette'
Data         = require '../../data/module'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'backbone.stickit'
require 'bootstrap.datetimepicker'

#-------------------------------------------------------------------------------
# Model
#-------------------------------------------------------------------------------

class Model extends Backbone.Model

  idAttribute: '_id'

  defaults:
    date:   moment()
    name:   ''
    muscle: []
    note:   ''
    body:   false

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  ui:
    dialog:     '#strength-modal-dialog'
    name:       '#strength-modal-name'
    muscle:     '#strength-modal-muscle'
    body:       '#strength-modal-body'
    submit:     '#strength-modal-submit'
    noteEnable: '#strength-modal-note-enable'
    note:       '#strength-modal-note'

  bindings:

    '#strength-modal-name': 'name'

    '#strength-modal-muscle':
      observe: 'muscle'
      onSet: (values) -> _.map values, (value) -> parseInt(value)

    '#strength-modal-note': 'note'

  events:

    'shown.bs.modal': ->
      @ui.body.prop 'checked', @model.get('body')
      return

    'click @ui.body': ->
      @model.set 'body', @ui.body.is(':checked')
      return

    'submit': (event) ->
      event.preventDefault()
      @rootChannel.request 'spin:page:loader', true

      @collection.create @model.attributes,
        wait: true
        at:   0
        success: (model) =>
          @rootChannel.request 'spin:page:loader', false
          @ui.dialog.modal('hide')

          # Finish, redirect to the actual strength log.

          @rootChannel.request 'strength:detail', model.id
          return
        error: (model, response) =>
          @rootChannel.request 'message:error', response
          return

      return

    'hidden.bs.modal': ->
      @ui.muscle.multiselect('destroy')
      return

    'click #strength-modal-note-enable': ->
      checked = @ui.noteEnable.is(':checked')
      if checked then @ui.note.removeClass('hide') else @ui.note.addClass('hide')
      return

  constructor: (options) ->
    super
    @mergeOptions options, 'edit'
    @rootChannel = Backbone.Radio.channel('root')

  onRender: ->

    date = moment(@model.get('date'))

    @ui.muscle.multiselect
      maxHeight:     300
      dropRight:     true
      buttonWidth:  '100%'
      buttonClass:  'btn btn-default'
    .multiselect 'dataprovider', Data.Muscles
    .multiselect('select', @model.get('muscle'))

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
