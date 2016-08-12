#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
Event        = require './event/module'
Schedule     = require './schedule/module'
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

      'show:schedule': =>

        sheduleModel = new Schedule.Model()
        sheduleModel.fetch
          success: (model) =>

            collection = new Schedule.Collection [],
              sLogs:   @sLogs
              sConfs:  @sConfs
              schedule: model
              parse:    true

            events = collection.toJSON()
            events = _.map events, (event) ->
              return _.assign event, allDay: true

            @showChildView 'calendar', new Schedule.View
              channel:       @channel
              model:          model
              calendarEvents: events
            return
          error: (model, response) =>
            @rootChannel.request 'message:error', response
            return

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
