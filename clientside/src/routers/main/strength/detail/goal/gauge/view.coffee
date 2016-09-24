#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

d3           = require 'd3'
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
    gold:   0
    silver: 0
    bronze: 0
    value:  0

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:
    level: '.strength-goal-level'

  serializeData: ->
    return {
      label: if @type is 'rep' then 'Reps' else 'Weight (lb)'
    }

  bindings:
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
    min    = @model.get('bronze')
    max    = @model.get('gold')
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

    value = _.clamp(@model.get('value'), min, max)

    gauge.set value

    scale = d3.scaleLinear()
    .domain([min, max])
    .range([0, 100])

    @ui.level.html _.round(scale(value), 0)

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

    @model.set 'value', @max todayValues

    # Get values omitting today.

    values = _ records
    .filter (record) =>
      searchDate = moment(@date).subtract(1, 'days')
      recordDate = moment(record.x)
      return recordDate.isBefore(searchDate.endOf('day'))
    .map (record) -> record.y
    .value()

    if @type is 'rep' then @reduceRep(values) else @reduceWeight(values)

    return values

  reduceWeight: (values) ->

    # Calculate ranking locally.

    decimals = 0

    mean     = @mean values
    margin   = standardDeviation(variance(values, mean))

    margin = 5 if margin is 0

    bronze = _.round((mean - margin) or mean, decimals) or 0
    bronze =  @roundUp5 bronze

    silver = _.round(mean, decimals) or 0
    silver =  @roundUp5 silver

    gold = _.round((mean + margin) or mean, decimals) or 0
    gold =  @roundUp5 gold

    @model.set
      bronze: bronze
      silver: silver
      gold:   gold

    return

  reduceRep: (values) ->

    decimals = 0

    mean     = @mean values
    margin   = standardDeviation(variance(values, mean))

    margin = 5 if margin is 0

    bronze = _.round((mean - margin) or mean, decimals) or 0

    silver = _.round(mean, decimals) or 0

    gold = _.round((mean + margin) or mean, decimals) or 0

    @model.set
      bronze: bronze
      silver: silver
      gold:   gold

    return

  min: (values)     -> _.min(values)

  max: (values)     -> _.max(values)

  mean: (values)    -> _.mean(values)

  roundUp5: (value) -> Math.ceil(value / 5) * 5

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
