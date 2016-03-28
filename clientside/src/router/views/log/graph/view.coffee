#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Backbone     = require 'backbone'
Marionette   = require 'marionette'
Highstock    = require 'highstock'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Series Rep Data
#-------------------------------------------------------------------------------

seriesRepData = (model) ->
  return {
    name: 'Reps'
    data: model.get('repData')
  }

#-------------------------------------------------------------------------------
# Series Weight Data
#-------------------------------------------------------------------------------

seriesWeightData = (model) ->
  return {
    name: 'Weight'
    data: model.get('weightData')
  }

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:
    chart: '#strength-log-graph-ui'

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')

  onRender: ->

    model = @collection.at(0)

    @chart = new Highstock.StockChart

      chart:
        type:     'areaspline'
        renderTo: @ui.chart[0]

      title:
        text: model.get('name').toUpperCase()
        style:
          fontWeight: 'bold'

      plotOptions:
        areaspline:
          fillOpacity: 0.3
          lineWidth:   3

        series:
          marker:
            radius:  2
            enabled: true

      xAxis:
        lineWidth: 2

      yAxis: [
        lineWidth: 2
        opposite:  false
      ]

      series: [seriesWeightData(model), seriesRepData(model)]

      legend:
        enabled:     true
        borderWidth: 2

      credits:
        enabled: false

    return

  # Chart does not stretch the full container unless reflow is called.

  onShow: ->
    @chart.reflow()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
