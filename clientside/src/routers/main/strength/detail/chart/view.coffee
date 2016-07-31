#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
Highcharts   = require 'highcharts'
Highstock    = require 'highstock'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Series Data
#-------------------------------------------------------------------------------

seriesData = (model, type) ->

  result =
    type:    'column'
    yAxis:   0
    shadow : true

  if type is 0
    return _.assign result,
      name:      'Reps'
      data:       model.get('repData')
      color:     '#98fb98'
      lineColor: '#6aaf6a'
      marker:
        enabled:    true
        fillColor: '#6aaf6a'
        radius:     6
  else
    return _.assign result,
      name:  'Weights'
      data:   model.get('weightData')
      color: '#b0e0e6'
      tooltip:
        valueSuffix: ' lb'
      lineColor: '#8cb3b8'
      marker:
        enabled:    true
        fillColor: '#8cb3b8'
        radius:     6

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

    @chart = new Highstock.StockChart

      chart:
        renderTo:        @ui.chart[0]
        height:           300
        marginTop:        5
        spacingBottom:    0
        spacingTop:       0
        spacingLeft:      0
        spacingRight:     0
        plotBorderColor: '#b2b2b2'
        plotBorderWidth:  0
        panning :         false

      rangeSelector:
        enabled: false

      navigator:
        enabled: false

      scrollbar:
        enabled: false

      plotOptions:
        column:
          stacking: 'normal'
          dataLabels:
            enabled: true
            color:  'white'
            style:
              textShadow: '0 0 3px black'

      xAxis:
        lineWidth: 2

      yAxis: [
        lineWidth: 0
        opposite:  false
      ]

      series: [
        seriesData(@model, 0)
        seriesData(@model, 1)
      ]

      legend:
        enabled: true

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
