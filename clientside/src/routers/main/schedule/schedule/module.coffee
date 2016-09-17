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
        right:  'agendaDay,agendaWeek'
      eventClick: (calEvent) =>
        @rootChannel.request 'strength:detail', calEvent.strengthID
        return

    @calendar.fullCalendar('today')
    @calendar.fullCalendar('changeView', 'agendaDay')

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
