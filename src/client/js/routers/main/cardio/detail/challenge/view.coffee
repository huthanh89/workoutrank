#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
Marionette   = require 'backbone.marionette'
viewTemplate = require './view.pug'

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
    help:           '#cardio-challenge-help'
    challenges:     '#cardio-challenges'
    goldDuration:   '#cardio-challenge-duration-gold'
    silverDuration: '#cardio-challenge-duration-silver'
    bronzeDuration: '#cardio-challenge-duration-bronze'

  constructor: (options) ->
    super(options)
    @mergeOptions options, [
      'cLogs'
      'date'
      'type'
    ]

    durationValues = []

    # Get value for each day.

    _.each @cLogs.models, (model) =>
      modelDate  = moment(model.get('date')).startOf('day')
      searchDate = moment(@date).startOf('day')
      if modelDate.isBefore searchDate
        durationValues.push model.get('duration')
      return

    @challenge =
      duration: @durationReduce durationValues

  onRender: ->

    @ui.goldDuration.html   @challenge.duration.gold
    @ui.silverDuration.html @challenge.duration.silver
    @ui.bronzeDuration.html @challenge.duration.bronze

    @ui.help.hide() unless @challenge.duration.gold is 0
    @ui.challenges.hide() unless @challenge.duration.gold > 0

    return

  onAttach: ->
    @ui.weightLabel.hide() if @type is 'duration'
    return

  durationReduce: (values) ->

    decimals = 0
    mean     = @mean values
    margin   = standardDeviation(variance(values, mean))

    return{
      bronze: _.round((mean - margin) or mean, decimals) or 0
      silver: _.round(mean, decimals)                    or 0
      gold:   _.round((mean + margin) or mean, decimals) or 0
    }
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
