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
    series.push model.attributes
  return series

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:
    chart: '#strength-graph-ui'

  constructor: (options) ->
    super
    @rootChannel = Backbone.Radio.channel('root')
    @mergeOptions options, 'title'

  onShow: ->

    @chart = new Highstock.StockChart

      chart:
        type:     'areaspline'
        renderTo: @ui.chart[0]

      title:
        text: @title.toUpperCase()
        style:
          fontWeight: 'bold'

      plotOptions:
        areaspline:
          fillOpacity: 0.3
          lineWidth:   3

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

      series: seriesData(@collection.models)

      legend:
        enabled:     true
        borderWidth: 2

      credits:
        enabled: false

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
