#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
Data         = require '../../data/module'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Given a collection, parse collection for rep and weight data.
#-------------------------------------------------------------------------------

parseCollection = (collection) ->

  weightData = []
  repData    = []

  collection.each (model) ->

    x = moment(model.get('date')).valueOf()

    weightData.push
      x: x
      y: model.get('weight')

    repData.push
      x: x
      y: model.get('rep')

  model = collection.at(0)

  return {
    exerciseID:   model.get('exercise')
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
  defaults:
    name:     ''
    exercise: ''
    muscle:    0
    weightMin: 0
    weightAvg: 0
    weightMax: 0
    repMin:    0
    repAvg:    0
    repMax:    0

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  bindings:

    '#log-table-name': 'name'

    '#log-table-muscle':
      observe: 'muscle'
      onGet: (value) -> _.find(Data.Muscles, value: value).label

    '#log-table-date':
      observe: 'date'
      onGet: (value) -> moment(value).format('MM/DD/YY')

    '#log-table-weight-max':
      observe: 'weightMax'

    '#log-table-weight-min':
      observe: 'weightMin'

    '#log-table-weight-avg':
      observe: 'weightAvg'

    '#log-table-rep-max':
      observe: 'repMax'

    '#log-table-rep-min':
      observe: 'repMin'

    '#log-table-rep-avg':
      observe: 'repAvg'

  constructor: (options) ->
    super
    @mergeOptions options, 'exerciseID'
    @rootChannel = Backbone.Radio.channel('root')
    @model = new Backbone.Model parseCollection(@collection)

  onRender: ->
    @stickit()
    @updateModel()
    return

  updateModel: () ->
    model = @model

    wieght = @reduce model.get('weightData')
    rep    = @reduce model.get('repData')

    @model.set
      name:       model.get('name')
      exerciseID: model.id
      muscle:     model.get('muscle')
      weightMin:  wieght.min
      weightMax:  wieght.max
      weightAvg:  wieght.avg
      repMin:     rep.min
      repMax:     rep.max
      repAvg:     rep.avg
    return

  reduce: (records) ->
    values = _.map(records, (record) -> record.y)

    return {
      min: @min(values)
      max: @max(values)
      avg: @avg(values)
    }

  min: (values) -> _.round(_.min(values), 2)

  max: (values) ->_.round(_.max(values),2)

  avg: (values) -> _.round(_.mean(values), 2)

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Model = Model
module.exports.View  = View

#-------------------------------------------------------------------------------
