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

  bindings:
    '#home-log-count': 'logCount'
    '#home-exercise-count': 'exerciseCount'

  events:

    'click #home-exercise': ->
      @rootChannel.request('strength')
      return

    'click #home-exercise-strength': ->
      @rootChannel.request('exercise:detail', 'strength')
      return

    'click #home-exercise-endurance': ->
      @rootChannel.request('exercise:detail', 'endurance')
      return

    'click #home-exercise-flexibility': ->
      @rootChannel.request('exercise:detail', 'flexibility')
      return

    'click #home-exercise-balance': ->
      @rootChannel.request('exercise:detail', 'balance')
      return

    'click #home-log': ->
      @rootChannel.request('log')
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

  onRender: ->
    @stickit()
    return


#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
