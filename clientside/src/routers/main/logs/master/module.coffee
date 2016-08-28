#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
GraphsView   = require './graphs/view'
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
    user:       ''

#-------------------------------------------------------------------------------
# Collection
#-------------------------------------------------------------------------------

class Collection extends Backbone.Collection

  url:  'api/logs'

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

  events:
    'click #graphs-home': ->
      @rootChannel.request 'home'
      return

  regions:
    graphs: '#logs-graphs-view'

  constructor: (options) ->
    super
    @mergeOptions options, 'sConfs'
    @rootChannel = Backbone.Radio.channel('root')

  onShow: ->
    @showChildView 'graphs', new GraphsView
      collection: @collection
      sConfs:     @sConfs
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

exports.Model      = Model
exports.Collection = Collection
exports.View       = View

#-------------------------------------------------------------------------------
