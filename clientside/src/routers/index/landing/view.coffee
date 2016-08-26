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
require 'backbone.validation'

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

  events:

    'click .index-signup-btn': ->
      @rootChannel.request('signup')
      return

    'click .index-login-btn': ->
      @rootChannel.request('login')
      return

    'click .index-try-btn': ->

      @rootChannel.request 'spin:page:loader', true

      model = new Model
        user:     'user'
        password: 'user'

      model.save {},
        success: (model) =>
          @rootChannel.request 'spin:page:loader', false
          @rootChannel.request 'show:'
          @rootChannel.request 'home'
          return
        error: (model, response) =>
          @rootChannel.request 'message:error', response
          return
      return

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
