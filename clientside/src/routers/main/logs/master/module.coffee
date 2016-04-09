#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
TableView    = require './table/view'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Model
#-------------------------------------------------------------------------------

class Model extends Backbone.Model

  idAttribute: '_id'

  defaults:
    name:  ''
    max:   0
    avg:   0
    count: 0
    date:  ''

#-------------------------------------------------------------------------------
# Collection
#-------------------------------------------------------------------------------

class Collection extends Backbone.Collection

  url:  'api/logs'

  model: Model

  parse: (response) ->

    result = []

    grouped = _.groupBy response, (record) -> record.exercise

    for exerciseID, records of grouped
      pr      = _.max records, (record) -> record.weight
      weights = _.map(records, (record) -> record.weight)

      result.push
        _id:   exerciseID
        name:  records[0].name
        date:  pr.date
        max:   pr.weight
        avg:   Math.round(_.mean(weights)) / 100
        count: records.length

    return result

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  regions:
    table: '#logs-table-view'

  onShow: ->
    @showChildView 'table', new TableView
      collection: @collection
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

exports.Model      = Model
exports.Collection = Collection
exports.View       = View

#-------------------------------------------------------------------------------
