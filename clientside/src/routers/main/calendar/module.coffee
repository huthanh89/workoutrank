#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
moment       = require 'moment'
Highcharts   = require 'highcharts'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
EventView    = require './event/view'
ScheduleView = require './schedule/view'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Model
#-------------------------------------------------------------------------------

class Model extends Backbone.Model
  defaults:
    id:    ''
    title: ''
    start: ''
    end:   ''

#-------------------------------------------------------------------------------
# Collection
#-------------------------------------------------------------------------------

class Collection extends Backbone.Collection

  model: Model

  parse: (response, options) ->

    result = []

    colors = Highcharts.getOptions().colors

    _.each options.sLogs.models, (model, index) ->
      for data in model.get('repData')
        result.push
          id:    data.id
          start: new Date moment(data.x)
          end:   new Date moment(data.x)
          title:  model.get('name')
          color: colors[index % colors.length]

      return

    return result

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

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')
    @channel = new Backbone.Radio.Channel('calendar')

    @channel.reply

      'show:events': =>
        events = @collection.toJSON()
        @showChildView 'calendar', new EventView
          collection:    @collection
          channel:       @channel
          calendarEvents: events
        return

      'show:schedule': =>
        events = @collection.toJSON()

        events = _.map events, (event) ->
          return _.assign event, allDay: true

        @showChildView 'calendar', new ScheduleView
          collection:    @collection
          channel:       @channel
          calendarEvents: events
        return

  onShow: ->
#    @channel.request 'show:events'
    @channel.request 'show:schedule'
    return

  onBeforeDestroy: ->
    @channel.reset()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

exports.Model      = Model
exports.Collection = Collection
exports.View       = View

#-------------------------------------------------------------------------------
