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
    ]
    @rootChannel = Backbone.Radio.channel('root')

  onShow: ->

    @calendar = @ui.calendar.fullCalendar
      events:     @calendarEvents
      eventOrder: 'color'
      header:
        left:   ''
        center: 'title'
        right:  'basicDay,basicWeek prev,next'

      eventClick: (calEvent) =>
        @rootChannel.request 'strength:detail', calEvent.strengthID
        return

      viewRender: (view,element) ->

        prev = $("#schedule-widget .fc-prev-button")
        next = $("#schedule-widget .fc-next-button")

        if moment(view.start).isAfter moment().startOf('week')
          prev.css('visibility','visible')
        else
          prev.css('visibility','hidden')

        if moment(view.end).isBefore moment().endOf('week')
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
