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
    help: '#strength-challenge-help'

    goldRep:    '#strength-challenge-rep-gold'
    goldWeight: '#strength-challenge-weight-gold'

    silverRep:    '#strength-challenge-rep-silver'
    silverWeight: '#strength-challenge-weight-silver'

    bronzeRep:    '#strength-challenge-rep-bronze'
    bronzeWeight: '#strength-challenge-weight-bronze'

    weightLabel: '.strength-challenge-weight'

  constructor: (options) ->
    super
    @mergeOptions options, [
      'sLogs'
      'date'
      'type'
    ]

    repValues    = []
    weightValues = []

    # Get value for each day.

    _.each @sLogs.models, (model) =>
      modelDate  = moment(model.get('date')).startOf('day')
      searchDate = moment(@date).startOf('day')
      if modelDate.isBefore searchDate
        repValues.push model.get('rep')
        weightValues.push model.get('weight')
      return

    @challenge =
      rep:    @repReduce    repValues
      weight: @weightReduce weightValues

  onRender: ->

    @ui.help.hide() unless @challenge.rep.gold is 0

    @ui.goldRep.html @challenge.rep.gold
    @ui.goldWeight.html @challenge.weight.gold

    @ui.silverRep.html @challenge.rep.silver
    @ui.silverWeight.html @challenge.weight.silver

    @ui.bronzeRep.html @challenge.rep.bronze
    @ui.bronzeWeight.html @challenge.weight.bronze

    return

  onShow: ->
    @ui.weightLabel.hide() if @type is 'rep'
    return

  repReduce: (values) ->

    decimals = 0
    mean     = @mean values
    margin   = standardDeviation(variance(values, mean))

    return{
      bronze: _.round((mean - margin) or mean, decimals) or 0
      silver: _.round(mean, decimals)                or 0
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
