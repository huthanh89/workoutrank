#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
Data         = require '../data/module'
EditView     = require './edit/view'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'fullcalendar'

#-------------------------------------------------------------------------------
# Model
#-------------------------------------------------------------------------------

class Model extends Backbone.Model

  idAttribute: '_id'

  urlRoot: '/api/schedule'

  defaults:
    sunday:    []
    monday:    []
    tuesday:   []
    wednesday: []
    thursday:  []
    friday:    []
    saturday:  []

#-------------------------------------------------------------------------------
# Collection
#-------------------------------------------------------------------------------

class Collection extends Backbone.Collection

  model: Model

  parse: (response, options) ->

    result = []

    days = [
      'sunday'
      'monday'
      'tuesday'
      'wednesday'
      'thursday'
      'friday'
      'saturday'
    ]

    schedule = _.pick options.schedule.attributes, days

    _.each options.sConfs.models, (model) ->
      for day, index in days
        if model.get('muscle') in schedule[day]
          result.push
            start: new Date moment().startOf('week').add(index, 'days')
            end:   new Date moment().startOf('week').add(index, 'days')
            title: model.get('name')
            color: Data.Colors[model.get('muscle') % Data.Colors.length]
      return

    return result

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

    @calendar.fullCalendar('today')
    @calendar.fullCalendar('changeView', 'basicWeek')

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
