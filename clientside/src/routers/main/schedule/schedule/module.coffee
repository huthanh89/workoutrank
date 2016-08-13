#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

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
    modal: '#calendar-modal-view'

  ui:
    calendar: '#calendar-widget'

  events:
    'click #calendar-tab': ->
      @channel.request 'show:events'
      return

    'click #calendar-edit': ->
      @showChildView 'modal', new EditView
        model:   @model
        channel: @channel
      return

    'click .calendar-table-edit': ->
      @rootChannel.request 'strengths'
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
      height:  650
      events: @calendarEvents
      header:
        left:   ''
        center: 'title'
        right:  ''

      eventClick: (calEvent) =>
        @rootChannel.request 'strength:detail', calEvent.strengthID
        return

    @calendar.fullCalendar('today')
    @calendar.fullCalendar('changeView', 'basicWeek')

    return

  onBeforeDestroy: ->
    @calendar.fullCalendar 'destroy'
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.View = View

#-------------------------------------------------------------------------------
