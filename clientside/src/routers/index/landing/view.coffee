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

    'click #index-google-play': ->
      window.open('https://play.google.com/store/apps/details?id=workoutrank.com.free&hl=en', '_blank')
      return

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
