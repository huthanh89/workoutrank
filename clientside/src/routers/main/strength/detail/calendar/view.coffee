#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
Marionette   = require 'marionette'
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
# Util functions
#-------------------------------------------------------------------------------

min  = (values) -> _.min(values)
max  = (values) -> _.max(values)
mean = (values) -> _.mean(values)

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:
    calendar: '#strength-calendar-ui'

  constructor: ->
    super
    @reduce()

  onRender: ->

    @ui.calendar.datepicker
      beforeShowDay: (date) =>

        rank = @dates[moment(date).startOf('day')]

        switch rank
          when 'gold'
            return {
              enabled: true
              classes: 'strength-calendar-td-gold'
              tooltip: ''
            }
          when 'silver'
            return {
              enabled: true
              classes: 'strength-calendar-td-silver'
              tooltip: ''
            }
          when 'bronze'
            return {
              enabled: true
              classes: 'strength-calendar-td-bronze'
              tooltip: ''
            }
          else
            return {
              enabled: false
              classes: ''
              tooltip: ''
            }

    return

  # Parse for rank placement values for weights goals.

  reduce: ->

    models = @collection.models
    dates  = {}

    # Get value for each day.

    _.each models, (model) ->
      day = moment(model.get('date')).startOf('day')
      dates[day] = [] if dates[day] is undefined
      dates[day].push model.get('weight')
      return

    # Get goal for dates before each day.

    first = true

    for date, values of dates

      weights = _ models
      .omitBy (model) ->
        modelDate = moment(model.get('date')).startOf('day')
        return modelDate.isAfter(moment(new Date(date)))
      .map (model) -> model.get('weight')
      .value()

      # Determine placements for each day.

      value = @max(values)
      avg   = @mean weights
      sd    = standardDeviation(variance(weights, _.mean(weights)))
      goal  = (avg + sd) or avg

      # Always give first day gold, because there isn't enough data.

      dates[date] = 'bronze'
      dates[date] = 'silver' if avg <= value < goal
      dates[date] = 'gold'   if (value >= goal) or first

      first = false

    @dates = dates

    return

  min: (values)  -> _.min(values)

  max: (values)  -> _.max(values)

  mean: (values) -> _.mean(values)

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
