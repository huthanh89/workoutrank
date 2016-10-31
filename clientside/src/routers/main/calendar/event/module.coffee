#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'fullcalendar'

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

    sConfs = options.sConfs
    _.each options.sLogs.models, (sLog) ->
      sConf = sConfs.get sLog.get('exercise')
      if sConf
        date = sLog.get('date')
        result.push
          start:   new Date moment(date)
          end:     new Date moment(date)
          title:   sConf.get('name')
          color:   '#fcbc28'
          modelID: sConf.id
          type:    'sLog'
      return

    cConfs = options.cConfs
    _.each options.cLogs.models, (cLog) ->

      cConf = cConfs.get cLog.get('exerciseID')

      if cConf
        date = cLog.get('date')
        result.push
          start:   new Date moment(date)
          end:     new Date moment(date)
          title:   cConf.get('name')
          color:   '#e0571d'
          modelID: cConf.id
          type:    'cLog'
      return

    _.each options.wLogs.models, (wLog) ->

      date = wLog.get('date')
      result.push
        start:   new Date moment(date)
        end:     new Date moment(date)
        title:   'Weight'
        color:   '#709de5'
        modelID: wLog.id
        type:    'wLog'
      return

    return result

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:
    calendar: '#calendar-widget'

  constructor: (options) ->
    super
    @mergeOptions options, [
      'channel'
      'calendarEvents'
    ]
    @rootChannel = Backbone.Radio.channel('root')

  onShow: ->
    @calendar = @ui.calendar.fullCalendar
      height: 'auto'
      events: @calendarEvents
      header:
        left:   'title'
        center: ''
        right:  'today prev,next'

      eventClick: (calEvent) =>
        switch calEvent.type
          when 'sLog'
            @rootChannel.request 'strength:detail', calEvent.modelID
          when 'cLog'
            @rootChannel.request 'cardio:detail', calEvent.modelID
          else
            @rootChannel.request 'weights'
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
