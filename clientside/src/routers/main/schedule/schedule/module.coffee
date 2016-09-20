#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

$            = require 'jquery'
_            = require 'lodash'
moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
EditView     = require './edit/view'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'fullcalendar'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  regions:
    modal: '#schedule-modal-view'

  ui:
    calendar: '#schedule-widget'
    edit:     '#schedule-edit'

  events:
    'click #schedule-tab': ->
      @channel.request 'show:events'
      return

    'click #schedule-edit': ->
      @showChildView 'modal', new EditView
        model:   @model
        channel: @channel
      return

    'click #schedule-table-edit': ->
      @rootChannel.request 'strengths'
      return

    'click #schedule-calendar-btn': ->
      @rootChannel.request 'calendar'
      return

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
        left:   ''
        center: 'title'
        right:  'prev,next basicDay,basicWeek'

      eventClick: (calEvent) =>
        @rootChannel.request 'strength:detail', calEvent.strengthID
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

        if models.length
          element.find(".fc-title").prepend("<i class='fa fa-check'></i>")
        return

      viewRender: (view) ->

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
