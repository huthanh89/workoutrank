#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'backbone.stickit'

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
    dialog: '#cardio-modal-dialog'
    name:   '#cardio-modal-name'
    muscle: '#cardio-modal-muscle'
    body:   '#cardio-modal-body'
    submit: '#cardio-modal-submit'

  bindings:

    '#cardio-modal-name': 'name'

    '#cardio-modal-note': 'note'

    '#cardio-modal-muscle':
      observe: 'muscle'
      onSet: (values) -> _.map values, (value) -> parseInt(value)

  events:

    'shown.bs.modal': ->
      @ui.body.prop 'checked', @model.get('body')
      return

    'click @ui.body': ->
      @model.set 'body', @ui.body.is(':checked')
      return

    'click #cardio-modal-delete': (event) ->
      event.preventDefault()
      @model.destroy
        wait: true
        success: =>
          @redirect = true
          @ui.dialog.modal('hide')
          return
        error: (model, response) =>
          @rootChannel.request 'message:error', response
          return

      return

    'submit': (event) ->
      event.preventDefault()

      @model.save {},
        success: =>
          @ui.dialog.modal('hide')
          return
        error: (model, response) =>
          @rootChannel.request 'message:error', response
          return

      return

    'hidden.bs.modal': ->
      @ui.muscle.multiselect('destroy')
      Backbone.Radio.channel('root').request('cardios') if @redirect
      return

  constructor: (options) ->
    super
    @mergeOptions options, [
      'edit'
      'summary'
    ]
    @rootChannel = Backbone.Radio.channel('root')
    @redirect    = false

  onRender: ->

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
