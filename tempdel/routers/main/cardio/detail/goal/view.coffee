#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
GaugeView    = require './gauge/view'
Marionette   = require 'backbone.marionette'
viewTemplate = require './view.pug'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.View

  template: viewTemplate

  ui:
    duration: '.cardio-goal-duration'

  regions:
    durationGauge: '.cardio-goal-duration-gauge-container'

  constructor: (options) ->
    super(options)
    @mergeOptions options, [
      'date'
      'cLogs'
      'cConf'
    ]

  onRender: ->

    durationData = []

    @cLogs.each (model) ->

      x = moment(model.get('date')).valueOf()

      durationData.push
        id: x
        x:  x
        y:  model.get('duration')

    @showChildView 'durationGauge', new GaugeView
      logs: durationData
      date: @date
      type: 'duration'

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
