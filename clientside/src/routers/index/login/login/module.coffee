#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

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

  url: 'api/login'

  defaults:
    user:     ''
    password: ''

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:
    form:   '#login-form'
    submit: '#login-submit'

  bindings:
    '#login-user':     'user'
    '#login-password': 'password'

  events:
    'click #login-signup': ->
      @rootChannel.request 'signup'
      return

    'click #login-forgot-user': ->
      @rootChannel.request 'forgot'
      return

    'submit': (event) ->
      event.preventDefault()
      @rootChannel.request 'spin:page:loader', true
      @model.save null,
        success: (model) =>
          @rootChannel.request 'spin:page:loader', false
          @rootChannel.request 'show:'
          @rootChannel.request 'home'
          return
        error: (model, response) =>
          @rootChannel.request 'message:error', response
          return
      return

  constructor: (options) ->
    super
    @rootChannel = Backbone.Radio.channel('root')
    @mergeOptions options, 'channel'

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
