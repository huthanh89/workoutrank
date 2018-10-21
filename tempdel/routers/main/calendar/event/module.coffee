#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
moment       = require 'moment'
Backbone     = require 'backbone'
Radio        = require 'backbone.radio'
Marionette   = require 'backbone.marionette'
Color        = require 'color/module'
viewTemplate = require './view.pug'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'fullcalendar'

#-------------------------------------------------------------------------------
# Channels
#-------------------------------------------------------------------------------

rootChannel = Radio.channel('root')

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

    result  = []
    opacity = 0.6

    # Parse Strength Logs.

    sConfs = options.sConfs
    _.each options.sLogs.models, (sLog) ->
      sConf = sConfs.get sLog.get('exercise')
      if sConf
        date = sLog.get('date')
        result.push
          start:   new Date moment(date)
          end:     new Date moment(date)
          title:   sConf.get('name')
          color:   Color.opacityColor '#fcbc28', opacity
          modelID: sConf.id
          type:    'sLog'
      return

    # Parse Cardio Logs.

    cConfs = options.cConfs
    _.each options.cLogs.models, (cLog) ->

      cConf = cConfs.get cLog.get('exerciseID')

      if cConf
        date = cLog.get('created')
        result.push
          start:   new Date moment(date)
          end:     new Date moment(date)
          title:   cConf.get('name')
          color:   Color.opacityColor '#e03224', opacity
          modelID: cConf.id
          type:    'cLog'
      return

    # Parse Weight Logs.

    _.each options.wLogs.models, (wLog) ->

      date = wLog.get('date')
      result.push
        start:   new Date moment(date)
        end:     new Date moment(date)
        title:   'Weight'
        color:   Color.opacityColor '#4a79b1', opacity
        modelID: wLog.id
        type:    'wLog'
      return

    return result

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.View

  template: viewTemplate

  ui:
    calendar: '#calendar-widget'

  constructor: (options) ->
    super(options)
    @mergeOptions options, [
      'channel'
      'calendarEvents'
    ]

  onAttach: ->
    @calendar = @ui.calendar.fullCalendar
      height: 'auto'
      events: @calendarEvents
      header:
        left:   'title'
        center: ''
        right:  'today prev,next'

      eventClick: (calEvent) ->
        switch calEvent.type
          when 'sLog'
            rootChannel.request 'strength:detail', calEvent.modelID
          when 'cLog'
            rootChannel.request 'cardio:detail', calEvent.modelID
          else
            rootChannel.request 'weights'
        return

    @calendar.fullCalendar('today')

    return

  onBeforeDestroy: ->
    @calendar.fullCalendar 'destroy'
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

exports.Model      = Model
exports.Collection = Collection
exports.View       = View

#-------------------------------------------------------------------------------
