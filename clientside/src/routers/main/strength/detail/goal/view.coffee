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
    rep:    '.strength-goal-rep'
    weight: '.strength-goal-weight'

  regions:
    repGauge:    '.strength-goal-rep-gauge-container'
    weightGauge: '.strength-goal-weight-gauge-container'

  constructor: (options) ->
    super
    @mergeOptions options, [
      'date'
      'sLogs'
      'sConf'
    ]

  onRender: ->

    weightData = []
    repData    = []

    @sLogs.each (model) ->

      x = moment(model.get('date')).valueOf()

      weightData.push
        id: x
        x:  x
        y:  model.get('weight')

      repData.push
        id: x
        x:  x
        y:  model.get('rep')

    @showChildView 'repGauge', new GaugeView
      logs: repData
      date: @date
      type: 'rep'

    if @sConf?.get('body') is false
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
