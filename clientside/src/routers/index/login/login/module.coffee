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
    user:    ''
    password: ''

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:
    form:   '#index-login-form'
    submit: '#index-login-submit'

  bindings:
    '#index-login-user':     'user'
    '#index-login-password': 'password'

  events:
    'submit': (event) ->
      event.preventDefault()
      @channel.request 'show:spinner'
      @model.save null,
        success: (model) =>
          @channel.request 'hide:spinner'
          @rootChannel.request('home')
          return
        error: (model, response) =>
          @channel.request 'hide:spinner'
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

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Model = Model
module.exports.View  = View

#-------------------------------------------------------------------------------
