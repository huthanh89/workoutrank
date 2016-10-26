#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
GaugeView    = require './gauge/view'
Marionette   = require 'marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  ui:
    rep:    '.cardio-goal-rep'
    weight: '.cardio-goal-weight'

  regions:
    repGauge:    '.cardio-goal-rep-gauge-container'
    weightGauge: '.cardio-goal-weight-gauge-container'

  constructor: (options) ->
    super
    @mergeOptions options, [
      'date'
      'cLogs'
      'cConf'
    ]

  onRender: ->

    weightData = []
    repData    = []

    @cLogs.each (model) ->

      x = moment(model.get('date')).valueOf()

      weightData.push
        id: x
        x:  x
        y:  model.get('weight')

      repData.push
        id: x
        x:  x
        y:  model.get('duration')

    @showChildView 'repGauge', new GaugeView
      logs: repData
      date: @date
      type: 'duration'

    if @cConf?.get('body') is false
      @showChildView 'weightGauge', new GaugeView
        logs: weightData
        date: @date
        type: 'weight'
    else
      @ui.weight.hide()
      @ui.rep.switchClass 'col-sm-6', 'col-sm-12'

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
