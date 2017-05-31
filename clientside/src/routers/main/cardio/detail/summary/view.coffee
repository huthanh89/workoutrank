#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'backbone.marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Variance
#-------------------------------------------------------------------------------

variance = (values, mean) ->
  result = []
  for value in values
    result.push Math.pow((value - mean), 2)
  return _.sum(result) / (values.length - 1)

#-------------------------------------------------------------------------------
# Standard Deviation
#-------------------------------------------------------------------------------

standardDeviation = (variance) -> Math.sqrt(variance)

#-------------------------------------------------------------------------------
# Model
#-------------------------------------------------------------------------------

class Model extends Backbone.Model
  defaults:
    name:          ''
    durationMin:   0
    durationAvg:   0
    durationMax:   0
    durationSD:    0
    durationTotal: 0

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.View

  template: viewTemplate

  ui:
    table: '#log-table'

  bindings:

    '#log-table-name': 'name'

    '#log-table-duration-min':
      observe: 'durationMin'
      onGet: (value) -> if value then value else '---'

    '#log-table-duration-max':
      observe: 'durationMax'
      onGet: (value) -> if value then value else '---'

    '#log-table-duration-avg':
      observe: 'durationAvg'
      onGet: (value) -> if value then value else '---'

    '#log-table-duration-sum':
      observe: 'durationSum'

  constructor: (options) ->
    super _.extend {}, options,
      model: new Model()

    @mergeOptions options, [
      'cConf'
      'cLogs'
    ]

  onRender: ->
    @stickit()
    @updateModel(@cConf, @cLogs)
    return

  updateModel: (cConf, cLogs) ->

    durationData = []

    cLogs.each (model) ->

      x = moment(model.get('date')).valueOf()

      durationData.push
        id: x
        x:  x
        y:  model.get('duration')

    duration = @reduce durationData

    @model.set
      name:       cConf.get('name')
      durationMin: duration.min
      durationMax: duration.max
      durationAvg: duration.avg
      durationSD:  duration.sd
      durationSum: duration.sum
    return

  reduce: (records) ->

    values = _.map(records, (record) -> record.y)
    sd     = standardDeviation(variance(values, _.mean(values)))

    return {
      min: @min(values)
      max: @max(values)
      avg: @avg(values)
      sum: @sum(values)
      sd:  _.round sd, 2
    }

  min: (values) -> _.round(_.min(values), 0)

  max: (values) -> _.round(_.max(values), 0)

  avg: (values) -> _.round(_.mean(values), 0)

  sum: (values) -> _.round(_.sum(values), 0)

  onBeforeDestroy: ->
    @unstickit()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
