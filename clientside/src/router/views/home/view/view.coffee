#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Backbone     = require 'backbone'
Marionette   = require 'marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  events:

    'click #home-exercise': ->
      @rootChannel.request('exercise')
      return
    'click #home-stat': ->
      @rootChannel.request('stat')
      return

    'click #home-schedule': ->
      @rootChannel.request('schedule')
      return

    'click #home-log': ->
      @rootChannel.request('log')
      return

    'click #home-multiplayer': ->
      @rootChannel.request('multiplayer')
      return

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
