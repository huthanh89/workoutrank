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
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:
    calendar: '#calendar-widget'

  events:
    'click #calendar-tab': ->
      @channel.request 'show:events'
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

    @calendar.fullCalendar('today')
    @calendar.fullCalendar('changeView', 'basicWeek')

    return

  onBeforeDestroy: ->
    @calendar.fullCalendar 'destroy'
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
