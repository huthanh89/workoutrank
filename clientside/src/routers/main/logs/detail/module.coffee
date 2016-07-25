#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
GraphView    = require './graph/view'
Table        = require './table/module'
viewTemplate = require './view.jade'

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

  parse: (response) ->

    result = []

    grouped = _.groupBy response, (record) -> record.exercise

    for exercise, records of grouped
      weightData = []
      repData    = []

      for record in records
        x = moment(record.date).valueOf()

        weightData.push
          id: x
          x:  x
          y:  record.weight

        repData.push
          id: x
          x:  x
          y:  record.rep

      result.push
        exerciseID:   exercise
        name:         records[0].name
        weightData: _.sortBy weightData, (point) -> point.x
        repData:    _.sortBy repData, (point) -> point.x
        muscle:       records[0].muscle
        user:         records[0].user

    return result

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  regions:
    graph: '#log-graph-view'
    table: '#log-table-view'

  events:
    'click #log-back': ->
      @rootChannel.request 'logs'
      return

  constructor: (options) ->
    super
    @rootChannel = Backbone.Radio.channel('root')
    @model = @collection.at(0)

  onShow: ->

    @showChildView 'graph', new GraphView
      collection: @collection

    @showChildView 'table', new Table.View
      collection: @collection
      model:      new Table.Model()
      exerciseID: @collection.at(0).id

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Model      = Model
module.exports.Collection = Collection
module.exports.View       = View

#-------------------------------------------------------------------------------
