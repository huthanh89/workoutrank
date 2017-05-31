#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

$            = require 'jquery'
_            = require 'lodash'
moment       = require 'moment'
Backbone     = require 'backbone'
Radio        = require 'backbone.radio'
Marionette   = require 'backbone.marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'fullcalendar'

#-------------------------------------------------------------------------------
# Channels
#-------------------------------------------------------------------------------

rootChannel = Radio.channel('root')

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.View

  template: viewTemplate

  ui:
    calendar: '#schedule-widget'

  constructor: (options) ->
    super
    @mergeOptions options, [
      'channel'
      'calendarEvents'
      'sLogs'
      'cLogs'
    ]

  onAttach: ->

    @calendar = @ui.calendar.fullCalendar
      height:     'auto'
      events:     @calendarEvents
      eventOrder: 'color'
      header:
        left:   'prev,next'
        center: 'title'
        right:  'basicDay,basicWeek'

      eventClick: (calEvent) ->

        if calEvent.type is 'strength'
          rootChannel.request 'strength:detail', calEvent.strengthID
        else if calEvent.type is 'cardio'
          rootChannel.request 'cardio:detail', calEvent.cardioID

        return

      eventRender: (view, element) =>

        # Filter for slogs the match day.

        sLogs = _ @sLogs.models
        .filter (model) ->
          return false unless (model.get('exercise') is view.strengthID)
          eventDate = moment(view.start).format('YYYY-MM-DD')
          sLogDate  = model.get('date')
          return true if eventDate is moment(sLogDate).format('YYYY-MM-DD')
          return false
        .value()

        # Filter for clogs the match day.

        cLogs = _ @cLogs.models
        .filter (model) ->
          return false unless (model.get('exerciseID') is view.cardioID)
          eventDate = moment(view.start).format('YYYY-MM-DD')

          cLogDate  = model.get('created')

          return true if eventDate is moment(cLogDate).format('YYYY-MM-DD')
          return false
        .value()
        title = element.find(".fc-title")

        if sLogs.length or cLogs.length
          title.prepend("<i class='fa fa-fw fa-check-square-o'></i>")
        else
          title.prepend("<i class='fa fa-fw fa-square-o'></i>")

        return

      viewRender: (view) =>

        prev = $("#schedule-widget .fc-prev-button")
        next = $("#schedule-widget .fc-next-button")

        if moment(view.start).startOf('day').isAfter moment().startOf('week')
          prev.css('visibility','visible')
        else
          prev.css('visibility','hidden')

        if moment(view.end).endOf('day').isBefore moment().endOf('week')
          next.css('visibility','visible')
        else
          next.css('visibility','hidden')

        if view.type is 'basicWeek'
          prev.css('visibility','hidden')
          next.css('visibility','hidden')

        @channel.request 'update:label', moment(view.end).day()

        return

    @calendar.fullCalendar('today')
    @calendar.fullCalendar('changeView', 'basicDay')

    @ui.edit.hide() unless Backbone.Radio.channel('user').request 'isOwner'

    return

  onBeforeDestroy: ->
    @calendar.fullCalendar 'destroy'
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.View = View

#-------------------------------------------------------------------------------
