#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

$            = require 'jquery'
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
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:
    calendar: '#schedule-widget'

  constructor: (options) ->
    super
    @mergeOptions options, [
      'channel'
      'calendarEvents'
      'sLogs'
    ]
    @rootChannel = Backbone.Radio.channel('root')

  onShow: ->

    @calendar = @ui.calendar.fullCalendar
      height:     'auto'
      events:     @calendarEvents
      eventOrder: 'color'
      header:
        left:   'prev,next'
        center: 'title'
        right:  'basicDay,basicWeek'

      eventClick: (calEvent) =>

        if calEvent.type is 'strength'
          @rootChannel.request 'strength:detail', calEvent.strengthID
        else if calEvent.type is 'cardio'
          @rootChannel.request 'cardio:detail', calEvent.cardioID

        return

      eventRender: (view, element) =>

        day = moment(view.start).startOf('day')

        models = _ @sLogs.models
        .filter (model) ->

          return false unless model.id is view.strengthID

          eventDate  = moment(view.start).format('YYYY-MM-DD')

          for data in model.get('repData')
            return true if eventDate is moment(data.x).format('YYYY-MM-DD')

          for data in model.get('weightData')
            return true if eventDate is moment(data.x).format('YYYY-MM-DD')

          return false

        .value()

        title = element.find(".fc-title")

        if models.length
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
