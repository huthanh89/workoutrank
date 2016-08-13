#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
Event        = require './event/module'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  regions:
    calendar: '#calendar-view-container'

  events:
    'click #calendar-home': ->
      @rootChannel.request 'home'
      return

    'click .calendar-table-edit': ->
      @rootChannel.request 'strengths'
      return

  constructor: (options) ->
    super
    @mergeOptions options, ['sConfs', 'sLogs']
    @rootChannel = Backbone.Radio.channel('root')
    @channel =     new Backbone.Radio.Channel('calendar')

    @channel.reply

      'show:events': =>
        collection = new Event.Collection [],
          sLogs:  @sLogs
          sConfs: @sConfs
          parse:  true
        events = collection.toJSON()
        @showChildView 'calendar', new Event.View
          collection:    @collection
          channel:       @channel
          calendarEvents: events
        return

  onShow: ->
    @channel.request 'show:events'
    return

  onBeforeDestroy: ->
    @channel.reset()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.View = View

#-------------------------------------------------------------------------------
