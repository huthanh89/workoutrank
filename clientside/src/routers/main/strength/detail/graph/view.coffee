#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'backbone.marionette'
Highcharts   = require 'highcharts'
Highstocks   = require 'highstock'
Color        = require 'color/module'
viewTemplate = require './view.pug'


#-------------------------------------------------------------------------------
# Given a collection, condense the collection to a single chart model.
#-------------------------------------------------------------------------------

chartModel = (model, collection) ->

  weightData = []
  repData    = []

  collection.each (model) ->

    x = moment(model.get('date')).valueOf()

    weightData.push
      id: x
      x:  x
      y:  model.get('weight')

    repData.push
      id: x
      x:  x
      y:  model.get('rep')

  return new Backbone.Model {
    exerciseID:   model.id
    name:         model.get('name')
    weightData: _.sortBy weightData, (point) -> point.x
    repData:    _.sortBy repData, (point) -> point.x
    muscle:       model.get('muscle')
    user:         model.get('user')
  }

#-------------------------------------------------------------------------------
# Series Data
#-------------------------------------------------------------------------------

seriesData = (model, type, chart) ->

  result =
    type:    chart
    yAxis:   0
    shadow : true
    marker:
      enabled:    true
      radius:     3

  if type is 0

    index = 2
    color = Color.indexColorHex(index)

    return _.assign result,
      name: 'Reps'
      data:  model.get('repData')
      color:     color
      lineColor: color
      fillColor:
        linearGradient:
          x1: 0
          y1: 0
          x2: 0
          y2: 1
        stops: [
          [
            0
            Color.opacityColor color, .1
          ]
          [
            1
            color
          ]
        ]
  else

    index = 3
    color = Color.indexColorHex(index)

    return _.assign result,
      name: 'Weights'
      data:  model.get('weightData')
      tooltip:
        valueSuffix: ' lb'
      color:     color
      lineColor: color
      fillColor:
        linearGradient:
          x1: 0
          y1: 0
          x2: 0
          y2: 1
        stops: [
          [
            0
            Color.opacityColor color, .1
          ]
          [
            1
            color
          ]
        ]

#-------------------------------------------------------------------------------
# Given a collection, return average weight in collection.
#-------------------------------------------------------------------------------

getMean = (data) -> _.mean(_.map(data, (record) -> record.y))

#-------------------------------------------------------------------------------
# Return plot line options for y axis.
#-------------------------------------------------------------------------------

plotLine = (text, value) ->
  return {
    value:      value
    width:      2
    color:     'red'
    dashStyle: 'shortdash'
    zIndex:     5
    label:
      text:   text
      float:  true
      align: 'left'
      x:      5
      style:
        fontWeight: 'bold'
        color:      '#d82a2a'
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

class View extends Marionette.View

  template: viewTemplate

  ui:
    container:   '#strength-log-graph-container'
    chartWeight: '#strength-log-graph-weight'
    chartRep:    '#strength-log-graph-rep'

  constructor: (options) ->

    super _.extend {}, options,
      model: chartModel options.sConf, options.sLogs

    @charts = []

  addChart: (container, model, type) ->

    name  = model.get('name')
    title = if type is 0 then 'Reps' else 'Weights'
    data  = if type is 0 then @model.get('repData') else @model.get('weightData')
    chart = new Highstocks.StockChart

      chart:
        renderTo:         container
        height:           180
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
          x: 5
        min: @min data
        max: @max data
      ]

      tooltip:
        shared: false

        style:
          fontSize:      '15px'
          fontWeight:    'bold'
        valueDecimals:    0

      series: [
        seriesData(model, type, 'areaspline')
      ]

      credits:
        enabled: false

    # Draw weight plot lines on chart.

    data = if type is 0 then model.get('repData') else model.get('weightData')
    mean = _.round(getMean(data), 0)
    chart.yAxis[0].addPlotLine plotLine("Avg: #{mean}", mean)

    # Call reflow so chart will fit 100% of the width container.

    chart.reflow()

    @charts.push chart

    return

  onAttach: ->

    @addChart(@ui.chartRep[0], @model, 0)
    @addChart(@ui.chartWeight[0], @model, 1)

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

  min: (values) -> _.min _.map values, (value) -> value.y

  max: (values) -> _.max _.map values, (value) -> value.y

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
