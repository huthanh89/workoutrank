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
# Given an index, return a HighChart color.
#-------------------------------------------------------------------------------

getColor = (index) ->
  colors = Highcharts.getOptions().colors
  return colors[index % colors.length]

#-------------------------------------------------------------------------------
# Series Data
#-------------------------------------------------------------------------------

seriesData = (model, index) ->

  color = getColor(index)

  return {
    name: 'Reps'
    yAxis: 0
    data:  model.get('repData')
    type: 'column'
    color: color
  }

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

plotLine = (title, value, color, opposite) ->
  return {
    value:      value
    width:      2
    #color:      color
    color:      'grey'
    dashStyle: 'shortdash'
    zIndex:     5
    label:
      text:  title
      float: true
      align: if opposite then 'right' else 'left'
      x:     -2
      style:
        fontWeight: 'bold'
#        color:       color
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
    @repIndex    = Math.ceil(Math.random() * (100 - 50) + 50)
    @weightIndex = Math.ceil(Math.random() * (50 - 1) + 1)
    @charts      = []

  addChart: (container, series) ->
    chart = new Highstocks.StockChart
      chart:
        renderTo: container
        height:   300

      plotOptions:
        series:
          marker:
            radius:  2
            enabled: true

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
          text: 'Rep'
          style:
            fontWeight: 'bold'
            fontSize:    14
            'letter-spacing': 2
      ,
        lineWidth: 1
        opposite:  true
      ]
      tooltip:
        shared: false
      series: [series]

    # Call reflow so chart will fit 100% of the width container.

    chart.reflow()

    @charts.push chart

    return

  onShow: ->

    model = @collection.at(0)

    @addChart(@ui.chartWeight[0], seriesData(model, @weightIndex))
    @addChart(@ui.chartRep[0], seriesData(model, @repIndex))

    @ui.container.bind 'mousemove touchmove touchstart', (e) =>

      chart = undefined
      point = undefined
      event = undefined
      i     = 0

      while i < @charts.length
        chart = @charts[i]
        event = chart.pointer.normalize(e.originalEvent)

        # Find coordinates within the chart
        point = chart.series[0].searchPoint(event, true)

        # Get the hovered point
        if point

          # Draw cross hair and show tool tips.
          for chart in @charts
            chart.xAxis[0].drawCrosshair event, point
            chart.tooltip.refresh point, e

        i = i + 1

      return

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
