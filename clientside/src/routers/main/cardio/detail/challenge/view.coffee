#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

$            = require 'jquery'
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
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:
    help:         '#cardio-challenge-help'
    challenges:   '#cardio-challenges'

    goldDuration:      '#cardio-challenge-Duration-gold'
    goldWeight:   '#cardio-challenge-weight-gold'

    silverDuration:    '#cardio-challenge-rep-silver'
    silverWeight: '#cardio-challenge-weight-silver'

    bronzeDuration:    '#cardio-challenge-rep-bronze'
    bronzeWeight: '#cardio-challenge-weight-bronze'

    weightLabel:  '.cardio-challenge-weight'

  constructor: (options) ->
    super
    @mergeOptions options, [
      'cLogs'
      'date'
      'type'
    ]

    repValues    = []
    weightValues = []

    # Get value for each day.

    _.each @cLogs.models, (model) =>
      modelDate  = moment(model.get('date')).startOf('day')
      searchDate = moment(@date).startOf('day')
      if modelDate.isBefore searchDate
        repValues.push model.get('duration')
        weightValues.push model.get('weight')
      return

    @challenge =
      rep:    @repReduce    repValues
      weight: @weightReduce weightValues

  onRender: ->

    @ui.goldDuration.html @challenge.rep.gold
    @ui.goldWeight.html @challenge.weight.gold

    @ui.silverDuration.html @challenge.rep.silver
    @ui.silverWeight.html @challenge.weight.silver

    @ui.bronzeDuration.html @challenge.rep.bronze
    @ui.bronzeWeight.html @challenge.weight.bronze


    @ui.help.hide() unless @challenge.rep.gold is 0
    @ui.challenges.hide() unless @challenge.rep.gold > 0

    return

  onShow: ->
    @ui.weightLabel.hide() if @type is 'duration'
    return

  repReduce: (values) ->

    decimals = 0
    mean     = @mean values
    margin   = standardDeviation(variance(values, mean))

    return{
      bronze: _.round((mean - margin) or mean, decimals) or 0
      silver: _.round(mean, decimals)                    or 0
      gold:   _.round((mean + margin) or mean, decimals) or 0
    }
    return

  weightReduce: (values) ->

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

    return{
      bronze: bronze
      silver: silver
      gold:   gold
    }

  min: (values)     -> _.min(values)

  max: (values)     -> _.max(values)

  mean: (values)    -> _.mean(values)

  roundUp5: (value) -> Math.ceil(value / 5) * 5

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
