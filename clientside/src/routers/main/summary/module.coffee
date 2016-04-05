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
  defaults:
    name: ''
    max:  0
    avg:  0

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
      pr      = _.max records, (record) -> record.weight
      weights = _.map(records, (record) -> record.weight)

      result.push
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
    table: '#stat-table-view'

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
