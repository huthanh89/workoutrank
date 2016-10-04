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
    username: ''
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
    '#login-user':     'username'
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
      @model.save {},
        success: =>
          @rootChannel.request 'spin:page:loader', false
          @rootChannel.request 'home'
          return
        error: (model, response) =>
          @rootChannel.request 'message:error', response
          return
      return

    'click #login-submit-facebook': (event) ->
      event.preventDefault()
      window.location = '/auth/facebook'
      return

    'click #login-submit-google': (event) ->
      event.preventDefault()
      model = new Backbone.Model()
      model.fetch
        url: 'api/login/google'
      return

    'click #login-submit-twitter': (event) ->
      event.preventDefault()
      window.location = '/auth/twitter'
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
