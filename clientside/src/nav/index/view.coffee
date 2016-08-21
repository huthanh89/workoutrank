#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Radio        = require 'backbone.radio'
Marionette   = require 'marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  events:
    'click #index-nav-logo': ->
      @channel.request 'index'
      return

  constructor: ->
    super
    @channel = Radio.channel('root')

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------