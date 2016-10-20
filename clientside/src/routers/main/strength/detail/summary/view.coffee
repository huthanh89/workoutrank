#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
Data         = require '../../data/module'
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
    name:       ''
    exercise:   ''
    muscle:      0
    weightMin:   0
    weightAvg:   0
    weightMax:   0
    weightSD:    0
    weightTotal: 0
    repMin:      0
    repAvg:      0
    repMax:      0
    repSD:       0
    repTotal:    0

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:
    table: '#log-table'

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
      onGet: (value) -> if value then value else '---'

    '#log-table-weight-min':
      observe: 'weightMin'
      onGet: (value) -> if value then value else '---'

    '#log-table-weight-avg':
      observe: 'weightAvg'
      onGet: (value) -> if value then value else '---'

    '#log-table-weight-sum':
      observe: 'weightSum'

    '#log-table-rep-min':
      observe: 'repMin'
      onGet: (value) -> if value then value else '---'

    '#log-table-rep-max':
      observe: 'repMax'
      onGet: (value) -> if value then value else '---'

    '#log-table-rep-avg':
      observe: 'repAvg'
      onGet: (value) -> if value then value else '---'

    '#log-table-rep-sum':
      observe: 'repSum'

  constructor: (options) ->
    super _.extend {}, options,
      model: new Model()

    @mergeOptions options, [
      'sConf'
      'sLogs'
    ]

    @rootChannel = Backbone.Radio.channel('root')

  onRender: ->
    @stickit()
    @updateModel(@sConf, @sLogs)
    return

  updateModel: (sConf, sLogs) ->

    weightData = []
    repData    = []

    sLogs.each (model) ->

      x = moment(model.get('date')).valueOf()

      weightData.push
        id: x
        x:  x
        y:  model.get('weight')

      repData.push
        id: x
        x:  x
        y:  model.get('rep')

    wieght = @reduce weightData
    rep    = @reduce repData

    @model.set
      name:       sConf.get('name')
      exerciseID: sConf.id
      muscle:     sConf.get('muscle')
      weightMin:  wieght.min
      weightMax:  wieght.max
      weightAvg:  wieght.avg
      weightSD:   wieght.sd
      weightSum:  wieght.sum
      repMin:     rep.min
      repMax:     rep.max
      repAvg:     rep.avg
      repSD:      rep.sd
      repSum:     rep.sum
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
