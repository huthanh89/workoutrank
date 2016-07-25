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
# Given a collection, condense the collection to a single chart model.
#-------------------------------------------------------------------------------

chartModel = (collection) ->

  weightData = []
  repData    = []

  collection.each (model) ->

    x = moment(model.get('date')).valueOf()

    weightData.push
      x: x
      y: model.get('weight')

    repData.push
      x: x
      y: model.get('rep')

  model = collection.at(0)

  return {
    exerciseID:   model.get('exercise')
    name:         model.get('name')
    weightData: _.sortBy weightData, (point) -> point.x
    repData:    _.sortBy repData, (point) -> point.x
    muscle:       model.get('muscle')
    user:         model.get('user')
  }

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
    @model       = new Backbone.Model chartModel(@collection)
    @repIndex    = Math.ceil(Math.random() * (100 - 50) + 50)
    @weightIndex = Math.ceil(Math.random() * (50 - 1) + 1)

  onRender: ->

    @chart = new Highstock.StockChart

      chart:
        renderTo: @ui.chart[0]
        height:    300
        marginTop: 5

      rangeSelector:
        enabled: false

      navigator:
        enabled: false

      scrollbar:
        enabled: false

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
        labels:
          enabled: false
      ,
        lineWidth: 1
        opposite:  true
        labels:
          enabled: false
      ]

      series: [
        seriesWeightData(@model, @weightIndex)
      ,
        seriesRepData(@model, @repIndex)
      ]

      legend:
        x:                35
        y:                2
        enabled:          true
        borderWidth:      2
        layout:          'vertical'
        align:           'left'
        verticalAlign:   'top'
        floating:         true
        backgroundColor: '#FFFFFF'

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
