#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
swal         = require 'sweetalert'
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

    'click #calendar-help': ->
      swal
        title: 'Instructions'
        text:  'The calendar shows recorded workouts. Try adding some workout in your journal first, then come back here to see them automatically posted.'
      return

    'click #calendar-schedule': ->
      @rootChannel.request 'schedule'
      return

  constructor: (options) ->
    super
    @mergeOptions options, ['sConfs', 'sLogs']
    @rootChannel = Backbone.Radio.channel('root')
    @channel     = new Backbone.Radio.Channel(@cid)

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
