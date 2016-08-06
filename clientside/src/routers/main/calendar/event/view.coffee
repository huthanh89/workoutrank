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

  constructor: (options) ->
    super
    @mergeOptions options, 'calendarEvents'
    @rootChannel = Backbone.Radio.channel('root')

  onShow: ->
    @calendar = @ui.calendar.fullCalendar
      height: 650
      events: @calendarEvents
    @calendar.fullCalendar('today')
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
