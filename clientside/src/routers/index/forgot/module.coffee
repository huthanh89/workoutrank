#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

swal         = require 'sweetalert'
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

  url: 'api/forgot'

  defaults:
    user: ''

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  bindings:
    '#forgot-user': 'user'

  modelEvents:
    sync: (model) ->
      model.clear().set(model.defaults)
      return

  events:
    'click #forgot-home': ->
      @rootChannel.request 'index'
      return

    'submit': (event) ->
      event.preventDefault()

      @rootChannel.request 'spin:page:loader', true

      @model.save null,
        success: (model) =>
          @rootChannel.request 'spin:page:loader', false
          swal
            title: 'Email Sent!'
            text:  'Please check your email for the code.'
            type:  'success'
          return
        error: (model, response) =>
          @rootChannel.request 'message:error', response
          return
      return

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')

  onRender: ->
    @stickit()
    return

  onBeforeDestroy: ->
    @unstickit()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Model = Model
module.exports.View  = View

#-------------------------------------------------------------------------------
