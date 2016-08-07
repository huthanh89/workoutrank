#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
moment       = require 'moment'
Highcharts   = require 'highcharts'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
EventView    = require './event/view'
viewTemplate = require './view.jade'

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

    colors = Highcharts.getOptions().colors

    _.each options.sLogs.models, (model, index) ->
      for data in model.get('repData')
        result.push
          id:    data.id
          start: new Date moment(data.x)
          end:   new Date moment(data.x)
          title:  model.get('name')
          color: colors[index % colors.length]

      return

    return result

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  regions:
    calendar: '#calendar-view-container'

  events:
    'click #calendar-home': ->
      @rootChannel.request 'home'
      return

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')

  onShow: ->
    events = @collection.toJSON()
    @showChildView 'calendar', new EventView
      collection:    @collection
      calendarEvents: events
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

exports.Model      = Model
exports.Collection = Collection
exports.View       = View

#-------------------------------------------------------------------------------
