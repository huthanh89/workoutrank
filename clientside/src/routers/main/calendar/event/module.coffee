#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
Data         = require '../data/module'
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

    _.each options.sLogs.models, (model) ->
      for data in model.get('repData')

        sConf = sConfs.get(model.id)

        if sConf
          result.push
            start:   new Date moment(data.x)
            end:     new Date moment(data.x)
            title:   sConf.get('name')
            color:   Data.Colors[_.sum(sConf.get('muscle')) % Data.Colors.length]
            modelID: model.id
      return

    return result

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:
    calendar: '#calendar-widget'

  events:
    'click #calendar-tab': ->
      @channel.request 'show:schedule'
      return

  constructor: (options) ->
    super
    @mergeOptions options, [
      'channel'
      'calendarEvents'
    ]
    @rootChannel = Backbone.Radio.channel('root')

  onShow: ->
    @calendar = @ui.calendar.fullCalendar
      height: 650
      events: @calendarEvents
      header:
        left:   'title'
        center: ''
        right:  'today prev,next'

      eventClick: (calEvent) =>
        @rootChannel.request 'strength:detail', calEvent.modelID
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
