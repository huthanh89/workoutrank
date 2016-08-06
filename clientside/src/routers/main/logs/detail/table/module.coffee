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

    '#log-table-weight-min':
      observe: 'weightMin'

    '#log-table-weight-avg':
      observe: 'weightAvg'

    '#log-table-weight-sd':
      observe: 'weightSD'

    '#log-table-weight-total':
      observe: 'weightTotal'

    '#log-table-rep-min':
      observe: 'repMin'

    '#log-table-rep-max':
      observe: 'repMax'

    '#log-table-rep-avg':
      observe: 'repAvg'

    '#log-table-rep-sd':
      observe: 'repSD'

    '#log-table-rep-total':
      observe: 'repTotal'

  constructor: (options) ->
    super
    @mergeOptions options, 'chartModel'
    @rootChannel = Backbone.Radio.channel('root')

  onRender: ->
    @stickit()
    @updateModel(@chartModel)
    return

  updateModel: (model) ->
    wieght = @reduce model.get('weightData')
    rep    = @reduce model.get('repData')

    @model.set
      name:        model.get('name')
      exerciseID:  model.id
      muscle:      model.get('muscle')
      weightMin:   wieght.min
      weightMax:   wieght.max
      weightAvg:   wieght.avg
      weightSD:    wieght.sd
      weightTotal: wieght.total
      repMin:      rep.min
      repMax:      rep.max
      repAvg:      rep.avg
      repSD:       rep.sd
      repTotal:    rep.total
    return

  reduce: (records) ->

    values = _.map(records, (record) -> record.y)
    sd     = standardDeviation(variance(values, _.mean(values)))

    return {
      min:  @min(values)
      max:  @max(values)
      avg:  @avg(values)
      total: values.length
      sd:  _.round sd, 2
    }

  min: (values) -> _.round(_.min(values), 2)

  max: (values) -> _.round(_.max(values),2)

  avg: (values) -> _.round(_.mean(values), 2)

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Model = Model
module.exports.View  = View

#-------------------------------------------------------------------------------
