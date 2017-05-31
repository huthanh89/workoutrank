#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
Color        = require 'color'
Backbone     = require 'backbone'
Marionette   = require 'backbone.marionette'
Highstocks   = require 'highstock'
Highcharts   = require 'highcharts'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Given a collection, condense the collection to a single chart model.
#-------------------------------------------------------------------------------

chartModel = (collection) ->
  data = []

  collection.each (model) ->
    x = moment(model.get('date')).valueOf()
    data.push
      id: x
      x:  x
      y:  model.get('weight')

  return new Backbone.Model {
    data: _.sortBy data, (point) -> point.x
  }

#-------------------------------------------------------------------------------
# Series Data
#-------------------------------------------------------------------------------

seriesData = (model, chart) ->

  index = 0
  color = Color Highcharts.getOptions().colors[index]

  return {
    type:    chart
    yAxis:   0
    shadow : true
    data:    model.get('data')
    name:   'Weights'
    tooltip:
      valueSuffix: ' lb'
    marker:
      enabled: true
      radius:  3
    color:     color.clone().darken(0.2).hslString()
    lineColor: color.clone().darken(0.2).hslString()
    fillColor:
      linearGradient:
        x1: 0
        y1: 0
        x2: 0
        y2: 1
      stops: [
        [
          0
          color.hslString()
        ]
        [
          1
          color.clearer(1).hslString()
        ]
      ]

  }

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
# View
#-------------------------------------------------------------------------------

class View extends Marionette.View

  template: viewTemplate

  ui:
    chart: '#body-graph-chart'

  constructor: (options) ->
    super
    @model = chartModel options.sLogs

  onAttach: ->

    data = @model.get('data')

    chart = new Highstocks.StockChart
      chart:
        renderTo:         @ui.chart[0]
        height:           190
        spacingBottom:    5
        spacingTop:       0
        spacingLeft:      5
        spacingRight:     0
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

      yAxis:  [
        lineWidth: 1
        opposite:  false
        crosshair: true
        title:
          enabled: false
        min: @min data
        max: @max data
      ]

      tooltip:
        shared: false

        style:
          fontSize:      '15px'
          fontWeight:    'bold'
        valueDecimals:    0
        formatter: ->
          '<span style="color: lightseagreen">' + moment(@x).format('DD MMM') + ': </span>' + @y

      series: [
        seriesData(@model, 'areaspline')
      ]


      credits:
        enabled: false

    # Draw weight plot lines on chart.

    mean = _.round(getMean(@model.get('data')), 1)
    chart.yAxis[0].addPlotLine plotLine("Avg: #{mean}", mean)

    # Call reflow so chart will fit 100% of the width container.

    chart.reflow()

    return
    
  min: (values) -> _.min _.map values, (value) -> value.y

  max: (values) -> _.max _.map values, (value) -> value.y

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
