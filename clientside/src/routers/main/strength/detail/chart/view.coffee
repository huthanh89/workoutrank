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
      color:     '#46dbd4'
      lineColor: '#65c2bd'
      yAxis:      0
      marker:
        enabled:    true
        fillColor: '#65c2bd'
        radius:     6
  else
    return _.assign result,
      name:      'Weights'
      data:       model.get('weightData')
      color:     '#e36e4b'
      lineColor: '#ca816b'
      yAxis:      1
      tooltip:
        valueSuffix: ' lb'
      marker:
        enabled:    true
        fillColor: '#ca816b'
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
          dataLabels:
            enabled: true
            color:  'gray'


      xAxis:
        lineWidth: 2

      yAxis: [
        lineWidth: 0
        opposite:  false
      ,
        lineWidth: 0
        opposite:  true
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
