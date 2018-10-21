#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

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

  url: 'api/login'

  defaults:
    username: ''
    password: ''

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.View

  template: viewTemplate

  ui:
    form:   '#login-form'
    submit: '#login-submit'

  bindings:
    '#login-user':     'username'
    '#login-password': 'password'

  events:
    'click #login-signup': ->
      rootChannel.request 'signup'
      return

    'click #login-forgot-user': ->
      rootChannel.request 'forgot'
      return

    'submit': (event) ->
      event.preventDefault()
      rootChannel.request 'spin:page:loader', true
      @model.save {},
        success: ->
          rootChannel.request 'spin:page:loader', false
          rootChannel.request 'home'
          return
        error: (model, response) ->
          rootChannel.request 'message:error', response
          return
      return

    'click #login-submit-facebook': (event) ->
      event.preventDefault()
      window.location = '/auth/facebook'
      return

    'click #login-submit-google': (event) ->
      event.preventDefault()
      window.location = '/auth/google'
      return

    'click #login-submit-twitter': (event) ->
      event.preventDefault()
      window.location = '/auth/twitter'
      return

    ###
    'click #login-google-play': ->
      window.open('https://play.google.com/store/apps/details?id=workoutrank.com.free&hl=en', '_blank')
      return
###

  constructor: (options) ->
    super(options)
    @mergeOptions options, [
      'channel'
    ]
    
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
