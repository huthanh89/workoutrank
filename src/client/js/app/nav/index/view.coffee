#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Radio        = require 'backbone.radio'
Marionette   = require 'backbone.marionette'
viewTemplate = require './view.pug'

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

  constructor: (options) ->
    super(options)
    @channel = Radio.channel('root')

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------