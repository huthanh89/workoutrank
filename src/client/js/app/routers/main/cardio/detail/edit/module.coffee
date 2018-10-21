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

require 'backbone.stickit'

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
    date:   moment()
    name:   ''
    note:   ''

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.View

  template: viewTemplate

  ui:
    dialog: '#cardio-modal-dialog'
    name:   '#cardio-modal-name'
    note:   '#cardio-modal-note'
    submit: '#cardio-modal-submit'

  bindings:
    '#cardio-modal-name': 'name'
    '#cardio-modal-note': 'note'

  events:

    'click #cardio-modal-delete': (event) ->
      event.preventDefault()
      @model.destroy
        wait: true
        success: =>
          @redirect = true
          @ui.dialog.modal('hide')
          return
        error: (model, response) ->
          rootChannel.request 'message:error', response
          return

      return

    'submit': (event) ->
      event.preventDefault()

      @model.save {},
        success: =>
          @ui.dialog.modal('hide')
          return
        error: (model, response) ->
          rootChannel.request 'message:error', response
          return

      return

    'hidden.bs.modal': ->
      Backbone.Radio.channel('root').request('cardios') if @redirect
      return

  constructor: (options) ->
    super(options)
    @mergeOptions options, [
      'edit'
      'summary'
    ]
    @redirect = false

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
