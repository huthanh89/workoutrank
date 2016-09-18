#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

Gauge = require 'gauge'

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
    min:   0
    max:   0
    avg:   0
    value: 0

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  bindings:

    '.strength-goal-min':   'min'
    '.strength-goal-max':   'max'
    '.strength-goal-value': 'value'

  constructor: (options) ->
    super _.extend {}, options,
      model: new Model()
    @mergeOptions options, [
      'logs'
      'date'
      'type'
    ]

  onRender: ->
    @stickit()
    @updateModel(@logs)
    return

  onShow: ->

    target = $(@el).find('.strength-goal-gauge')[0]
    min    = @model.get('min')
    max    = @model.get('max')
    color  = if @type is 'rep' then '#00ffa4' else '#FE7935'

    opts =
      lines:            12
      angle:            0.15
      lineWidth:        0.44
      limitMax:        'false'
      colorStart:       color
      colorStop:        color
      strokeColor:     '#E0E0E0'
      generateGradient: true
      pointer:
        length:      0.8
        strokeWidth: 0.035
        color:      '#000000'

    gauge  = new Gauge.Gauge(target).setOptions(opts)

    gauge.minValue       = min
    gauge.maxValue       = max
    gauge.animationSpeed = 83

    gauge.set _.clamp @model.get('value'), min, max

    return

  # Calculate reduce using data values before date passed in.

  updateModel: (records) ->

    # Get values that is within search date.

    todayValues = _ records
    .filter (record) =>
      searchDate = moment(@date)
      recordDate = moment(record.x)
      return recordDate.isAfter(searchDate.startOf('day')) && recordDate.isBefore(searchDate.endOf('day'))
    .map (record) -> record.y
    .value()

    # Get values omitting today.

    values = _ records
    .filter (record) =>
      searchDate = moment(@date).subtract(1, 'days')
      recordDate = moment(record.x)
      return recordDate.isBefore(searchDate.endOf('day'))
    .map (record) -> record.y
    .value()

    # There must be an sd. If there is none just set it to an arbitrary 1.

    avg   = @avg(values)
    sd    = standardDeviation(variance(values, _.mean(values))) or 1
    value = _.round(@max(todayValues), 1) or 0
    min   = (avg - sd) or 0
    max   = (avg + sd) or value

    decimals = 0

    @model.set
      value: value
      min:   _.round(min, decimals)
      max:   _.round(max, decimals)
      avg:   _.round(avg, decimals)
      sd:    _.round(sd, decimals)

    return

  min: (values) -> _.round(_.min(values), 2)

  max: (values) -> _.round(_.max(values),2)

  avg: (values) -> _.round(_.mean(values), 2)

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
