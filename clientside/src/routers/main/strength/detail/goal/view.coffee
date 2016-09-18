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

  regions:
    repGauge:    '.strength-goal-rep-gauge-container'
    weightGauge: '.strength-goal-weight-gauge-container'

  constructor: (options) ->
    super
    @mergeOptions options, [
      'date'
      'sLogs'
    ]

  onShow: ->

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

    @showChildView 'weightGauge', new GaugeView
      logs: weightData
      date: @date
      type: 'weight'

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
