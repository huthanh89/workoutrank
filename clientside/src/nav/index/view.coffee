#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Radio        = require 'backbone.radio'
Marionette   = require 'backbone.marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.View

  template: viewTemplate

  events:
    'click #index-nav-logo': ->
      @channel.request 'index'
      return

    'click #index-nav-banner': ->
      @channel.request 'index'
      return

    'click #index-nav-login': ->
      @channel.request 'login'
      return

    'click #index-nav-signup': ->
      @channel.request 'signup'
      return

  constructor: ->
    super
    @channel = Radio.channel('root')

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------