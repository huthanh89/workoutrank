#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Backbone     = require 'backbone'
Marionette   = require 'marionette'
Highcharts   = require 'highcharts'
Highstock    = require 'highstock'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Given an index, return a HighChart color.
#-------------------------------------------------------------------------------

getColor = (index) ->
  colors = Highcharts.getOptions().colors
  return colors[index % colors.length]

#-------------------------------------------------------------------------------
# Series Rep Data
#-------------------------------------------------------------------------------

seriesRepData = (model, index) ->

  color = getColor(index)

  return {
    name: 'Reps'
    yAxis: 0
    data:  model.get('repData')
    type: 'column'
    color: color
  }

#-------------------------------------------------------------------------------
# Series Weight Data
#-------------------------------------------------------------------------------

seriesWeightData = (model, index) ->

  color = getColor(index)

  return {
    name: 'Weight'
    yAxis: 1
    data: model.get('weightData')
    type: 'areaspline'
    color: color
    fillColor:
      linearGradient:
        x1: 0,
        y1: 0,
        x2: 0,
        y2: 1
      stops : [
        [ 0, color],
        [.9, Highcharts.Color(color).setOpacity(0).get('rgba')]
      ]
    threshold: null
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
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:
    chart: '#strength-log-graph-ui'

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')

    @repIndex    = Math.ceil(Math.random() * (100 - 50) + 50)
    @weightIndex = Math.ceil(Math.random() * (50 - 1) + 1)

  onRender: ->

    model = @collection.at(0)

    @chart = new Highstock.StockChart

      chart:
        renderTo: @ui.chart[0]
        height:   500

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
        lineWidth: 1
        opposite:  false
        title:
          text: 'Rep'
          style:
            fontWeight: 'bold'
            fontSize:    14
            'letter-spacing': 2
      ,
        lineWidth: 1
        opposite:  true
        title:
          text: 'Weight'
          style:
            fontWeight:      'bold'
            fontSize:         14
            'letter-spacing': 2
      ]

      series: [
        seriesWeightData(model, @weightIndex)
      ,
        seriesRepData(model, @repIndex)
      ]

      legend:
        enabled:     true
        borderWidth: 2

      credits:
        enabled: false

    ###
    # Draw rep plot lines on chart.

    mean  = getMean(model.get('repData'))
    color = getColor(@repIndex)
    @chart.yAxis[1].addPlotLine plotLine('Average Rep', mean, color, false)

###

    # Draw weight plot lines on chart.

    mean  = _.round(getMean(model.get('weightData')), 0)
    color = getColor(@weightIndex)
    @chart.yAxis[1].addPlotLine plotLine("Avg Weight: #{mean}", mean, color, true)

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
