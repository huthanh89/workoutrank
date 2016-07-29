#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

$            = require 'jquery'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
Highcharts   = require 'highcharts'
Highstocks   = require 'highstock'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Series Data
#-------------------------------------------------------------------------------

seriesData = (model, type, chart) ->

  result =
    type:    chart
    yAxis:   0
    shadow : true

  if type is 0
    return _.assign result,
      name: 'Reps'
      data:  model.get('repData')
      color: '#98fb98'
      lineColor: '#6aaf6a'
      marker:
        enabled:    true
        fillColor: '#6aaf6a'
        radius:     6
  else
    return _.assign result,
      name: 'Weights'
      data:  model.get('weightData')
      color: '#b0e0e6'
      tooltip:
        valueSuffix: ' lb'
      lineColor: '#8cb3b8'
      marker:
        enabled:    true
        fillColor: '#8cb3b8'
        radius:     6

#-------------------------------------------------------------------------------
# Given a collection, return average weight in collection.
#-------------------------------------------------------------------------------

getMean = (data) -> _.mean(_.map(data, (record) -> record.y))

#-------------------------------------------------------------------------------
# Given a collection, return max weight in collection.
#-------------------------------------------------------------------------------

getMax = (data) -> _.maxBy(data, (record) -> record.y).y

#-------------------------------------------------------------------------------
# Return plot line options for y axis.
#-------------------------------------------------------------------------------

plotLine = (text, value) ->
  return {
    value:      value
    width:      2
    color:     'grey'
    dashStyle: 'shortdash'
    zIndex:     5
    label:
      text:   text
      float:  true
      align: 'left'
      x:      5
      style:
        fontWeight: 'bold'
        color:      'grey'
  }

#-------------------------------------------------------------------------------
# Sync chart extremes
#-------------------------------------------------------------------------------

syncExtremes = (e) ->
  thisChart = @chart
  if e.trigger != 'syncExtremes'
    Highcharts.each Highcharts.charts, (chart) ->
      if chart != thisChart
        if chart.xAxis[0].setExtremes
          chart.xAxis[0].setExtremes e.min, e.max, undefined, false, trigger: 'syncExtremes'
      return
  return

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:
    container:   '#strength-log-graph-container'
    chartWeight: '#strength-log-graph-weight'
    chartRep:    '#strength-log-graph-rep'

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')
    @charts      = []

  addChart: (container, model, type) ->

    name  = model.get('name')
    title = if type is 0 then 'Reps' else 'Weights'

    chart = new Highstocks.StockChart

      chart:
        renderTo:         container
        height:           300
        spacingBottom:    5
        spacingTop:       0
        spacingLeft:     -10
        spacingRight:     10
        plotBorderColor: '#b2b2b2'
        plotBorderWidth:  2
        panning :         false

      title:
        enabled: false

      rangeSelector:
        enabled: false

      navigator:
        enabled: false

      scrollbar:
        enabled: false

      xAxis:
        lineWidth: 2
        crosshair: true
        events:
          setExtremes: syncExtremes

      yAxis:  [
        lineWidth: 1
        opposite:  false
        crosshair: true
        title:
          text: title
          style:
            fontWeight: 'bold'
            fontSize:    14
      ]

      tooltip:
        shared: false

        style:
          fontSize:      '15px'
          fontWeight:    'bold'
        valueDecimals:    0

      series: [
        seriesData(model, type, 'column')
        seriesData(model, type, 'line')
      ]

      credits:
        enabled: false

    # Draw weight plot lines on chart.

    data = if type is 0 then model.get('repData') else model.get('weightData')
    mean = _.round(getMean(data), 1)
    chart.yAxis[0].addPlotLine plotLine("Average: #{mean}", mean)

    # Call reflow so chart will fit 100% of the width container.

    chart.reflow()

    @charts.push chart

    return

  onShow: ->

    model = @collection.at(0)

    @addChart(@ui.chartRep[0], model, 0)
    @addChart(@ui.chartWeight[0], model, 1)

    @ui.container.bind 'mousemove touchmove touchstart', (e) =>

      chart = undefined
      point = undefined
      event = undefined

      for chart, index in @charts
        chart = @charts[index]
        event = chart.pointer.normalize(e.originalEvent)

        # Find coordinates within the chart
        point = chart.series[0].searchPoint(event, true)

        # Get the hovered point
        if point

          # For each chart find the actual point by id then
          # draw cross hair and tooltip.

          for chart in @charts
            point = chart.get(point.x)
            chart.xAxis[0].drawCrosshair event, point
            chart.tooltip.refresh point, e

      return

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
