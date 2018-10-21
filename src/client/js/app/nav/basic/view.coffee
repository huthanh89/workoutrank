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

  ###
  events:
    'click #basic-nav-logo': ->
      @channel.request 'index'
      return

    'click #basic-nav-banner': ->
      @channel.request 'index'
      return
###

  constructor: (options) ->
    super(options)
    @channel = Radio.channel('root')

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------