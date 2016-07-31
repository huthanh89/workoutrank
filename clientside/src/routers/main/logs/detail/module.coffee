#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
GraphView    = require './graph/view'
CalendarView = require './calendar/view'
Table        = require './table/module'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'backbone.stickit'

#-------------------------------------------------------------------------------
# Given a collection, condense the collection to a single chart model.
#-------------------------------------------------------------------------------

chartModel = (model, collection) ->

  weightData = []
  repData    = []

  collection.each (model) ->

    x = moment(model.get('date')).valueOf()

    weightData.push
      id: x
      x:  x
      y:  model.get('weight')

    repData.push
      id: x
      x:  x
      y:  model.get('rep')

  return new Backbone.Model {
    exerciseID:   model.id
    name:         model.get('name')
    weightData: _.sortBy weightData, (point) -> point.x
    repData:    _.sortBy repData, (point) -> point.x
    muscle:       model.get('muscle')
    user:         model.get('user')
  }

#-------------------------------------------------------------------------------
# Model
#-------------------------------------------------------------------------------

class Model extends Backbone.Model

  idAttribute: 'exerciseID'

  defaults:
    exerciseID: ''
    name:       ''
    weightData: []
    repData:    []

#-------------------------------------------------------------------------------
# Collection
#-------------------------------------------------------------------------------

class Collection extends Backbone.Collection

  constructor: (models, options) ->
    super
    @url = "/api/strengths/#{options._id}/log"

  model: Model

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  regions:
    graph:    '#log-graph-view'
    table:    '#log-table-view'
    calendar: '#log-calendar-view'

  events:
    'click #graph-home': ->
      @rootChannel.request 'home'
      return

    'click #graph-graphs': ->
      @rootChannel.request 'logs'
      return

    'click .log-table-edit': ->
      @rootChannel.request 'strength:detail', @model.get('exerciseID')
      return

  bindings:
    '#log-title': 'name'

  constructor: (options) ->
    super
    @mergeOptions options, 'sConf'
    @rootChannel = Backbone.Radio.channel('root')
    @model = chartModel(@sConf, @collection)

  onRender: ->
    @stickit()
    return

  onShow: ->

    @showChildView 'table', new Table.View
      model:      new Table.Model()
      chartModel: @model

    @showChildView 'graph', new GraphView
      model: @model

    @showChildView 'calendar', new CalendarView
      model: @model

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Model      = Model
module.exports.Collection = Collection
module.exports.View       = View

#-------------------------------------------------------------------------------
