#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

$            = require 'jquery'
moment       = require 'moment'
Marionette   = require 'backbone.marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'datepicker'

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
# View
#-------------------------------------------------------------------------------

class View extends Marionette.View

  template: viewTemplate

  ui:
    calendar: '#cardio-calendar-ui'

  constructor: (options) ->
    super
    @mergeOptions options, [
      'type'
    ]
    @reduce()

  onRender: ->

    datepicker = @ui.calendar.datepicker
      beforeShowDay: (date) =>

        rank = @dates[moment(date).startOf('day')]

        switch rank
          when 'gold'
            return {
              enabled: true
              classes: 'cardio-calendar-td-gold'
              tooltip: ''
            }
          when 'silver'
            return {
              enabled: true
              classes: 'cardio-calendar-td-silver'
              tooltip: ''
            }
          when 'bronze'
            return {
              enabled: true
              classes: 'cardio-calendar-td-bronze'
              tooltip: ''
            }
          else
            return {
              enabled: false
              classes: ''
              tooltip: ''
            }
    return

  onAttach: ->

    medals = _.valuesIn @dates

    $('#cardio-trophy-gold').html _.filter(medals, (medal) -> medal is 'gold').length

    $('#cardio-trophy-silver').html _.filter(medals, (medal) -> medal is 'silver').length

    $('#cardio-trophy-bronze').html _.filter(medals, (medal) -> medal is 'bronze').length

    return

  # Parse for rank placement values for typeValues goals.

  reduce: ->

    type   = @type
    models = @collection.models
    dates  = {}

    # Get value for each day.

    _.each models, (model) ->
      day = moment(model.get('date')).startOf('day')
      dates[day] = [] if dates[day] is undefined
      dates[day].push model.get(type)
      return

    # Get goal for dates before each day.

    first = true

    for date, values of dates

      typeValues = _ models
      .omitBy (model) ->
        modelDate = moment(model.get('date')).startOf('day')
        return modelDate.isAfter(moment(new Date(date)).subtract(1, 'days'))
      .map (model) -> model.get(type)
      .value()

      # Determine placements for each day.

      decimals = 0
      value    = _.round(@max(values), decimals)
      avg      = @mean typeValues
      margin   = standardDeviation(variance(typeValues, _.mean(typeValues)))
      goal     = _.round((avg + margin) or avg, decimals) or 0

      # Always give first day gold, because there isn't enough data.

      dates[date] = 'bronze'
      dates[date] = 'silver' if avg <= value < goal
      dates[date] = 'gold'   if (value >= goal) or first

      first = false

    @dates = dates

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
