#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

$            = require 'jquery'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
Highstock    = require 'highstock'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Series Data
#-------------------------------------------------------------------------------

seriesData = (models) ->
  series = []
  for model in models
    series.push model
  return series

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:
    chart: '#strength-log-graph-ui'

  constructor: (options) ->
    super
    @rootChannel = Backbone.Radio.channel('root')

  onRender: ->

    @chart = new Highstock.StockChart

      chart:
        type:     'areaspline'
        renderTo: @ui.chart[0]

      title:
        #text: @model.get('name').toUpperCase()
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
        title:
          text: 'Time'
          style:
            fontWeight: 600
            fontSize:  '12px'

      yAxis: [
        lineWidth: 2
        opposite:  false
        title:
          text: 'Weight'
          style:
            fontWeight: 600
            fontSize:  '12px'
      ]

      series: seriesData(@collection.at(0).get('data'))

      legend:
        enabled:     true
        borderWidth: 2

      credits:
        enabled: false

    return

  onShow: ->

    # Chart does not stretch the full container unless reflow is called.

    @chart.reflow()

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
