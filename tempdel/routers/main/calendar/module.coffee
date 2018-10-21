#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
swal         = require 'sweetalert'
Backbone     = require 'backbone'
Radio        = require 'backbone.radio'
Marionette   = require 'backbone.marionette'
Event        = require './event/module'
viewTemplate = require './view.pug'

#-------------------------------------------------------------------------------
# Channels
#-------------------------------------------------------------------------------

rootChannel = Radio.channel('root')

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.View

  template: viewTemplate

  regions:
    calendar: '#calendar-view-container'

  events:
    'click #calendar-home': ->
      rootChannel.request 'home'
      return

    'click #calendar-help': ->
      swal
        title: 'Instructions'
        text:  'The calendar shows recorded workouts. Try adding some workout in your journal first, then come back here to see them automatically posted.'
      return

  constructor: (options) ->
    super(options)
    @mergeOptions options, [
      'cConfs'
      'cLogs'
      'sConfs'
      'sLogs'
      'wLogs'
    ]
    @channel = new Backbone.Radio.Channel(@cid)

    @channel.reply

      'show:events': =>
        collection = new Event.Collection [],
          cLogs:  @cLogs
          cConfs: @cConfs
          sLogs:  @sLogs
          sConfs: @sConfs
          wLogs:  @wLogs
          parse:  true
        events = collection.toJSON()
        @showChildView 'calendar', new Event.View
          collection:    @collection
          channel:       @channel
          calendarEvents: events
        return

  onAttach: ->
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
