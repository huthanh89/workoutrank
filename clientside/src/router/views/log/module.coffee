#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
GraphView    = require './graph/view'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Model
#-------------------------------------------------------------------------------

class Model extends Backbone.Model

  defaults:
    name: ''
    data: []

#-------------------------------------------------------------------------------
# Collection
#-------------------------------------------------------------------------------

class Collection extends Backbone.Collection

  url: '/api/log'

  parse: (response) ->
    result = []

    grouped = _.groupBy response, (record) -> record.exercise

    for exercise, records of grouped
      weightData = []
      repData    = []

      for record in records
        x = moment(record.date).valueOf()

        weightData.push
          x: x
          y: record.weight

        repData.push
          x: x
          y: record.rep

      result.push
        exercise:   exercise
        name:       records[0].name
        weightData: weightData
        repData:    repData

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
    'click #log-home': ->
      @rootChannel.request 'home'
      return

  constructor: (options) ->
    super
    @rootChannel = Backbone.Radio.channel('root')

  onRender: ->
    @stickit()
    return

  onShow: ->
    @showChildView 'graph', new GraphView
      collection: @collection

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Model      = Model
module.exports.Collection = Collection
module.exports.View       = View

#-------------------------------------------------------------------------------
