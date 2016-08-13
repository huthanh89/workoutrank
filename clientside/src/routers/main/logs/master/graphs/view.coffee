#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

$            = require 'jquery'
_            = require 'lodash'
moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
Highcharts   = require 'highcharts'
Highstock    = require 'highstock'
nullTemplate = require './null.jade'
itemTemplate = require './item.jade'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'multiselect'
require 'backbone.stickit'
require 'jquery.ui'

#-------------------------------------------------------------------------------
# Given an array of y values, return its max value.
#-------------------------------------------------------------------------------

getMax = (data) -> _.maxBy(_.map(data, (record) -> record.y))

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
        radius:     3
  else
    return _.assign result,
      name:      'Weights'
      data:       model.get('weightData')
      color:     '#00ffa4'
      lineColor: '#00B272'
      yAxis:      1
      tooltip:
        valueSuffix: ' lb'
      marker:
        enabled:    true
        fillColor: '#00B272'
        radius:     6

#-------------------------------------------------------------------------------
# Null View
#-------------------------------------------------------------------------------

class NullView extends Marionette.ItemView
  template: nullTemplate

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class ItemView extends Marionette.ItemView

  template: itemTemplate

  ui:
    chart: '.graph-chart'
    name:  '.graph-name'

  events:
    'click': ->
      @rootChannel.request 'log:detail', @model.get('exerciseID')
      return

  constructor: (options) ->
    super
    @mergeOptions options, 'sConfs'
    @rootChannel = Backbone.Radio.channel('root')

  onRender: ->

    # Look up graph's name and display it.

    @ui.name.text @sConfs.get(@model.id).get('name')

    # Create chart.

    @chart = new Highstock.StockChart

      chart:
        renderTo:        @ui.chart[0]
        height:           110
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

      xAxis:
        lineWidth: 2

      yAxis: [
        lineWidth: 0
        opposite:  false
        min:       0
        max:       getMax(@model.get('repData'))
        crop: false
      ,
        lineWidth: 0
        opposite:  true
        min:       0
        max:       getMax(@model.get('weightData'))
      ]

      series: [
        seriesData(@model, 0)
        seriesData(@model, 1)
      ]

      legend:
        enabled: false

      credits:
        enabled: false

    return

  onShow: ->
    @chart.reflow()
    return

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.CompositeView

  childView: ItemView

  emptyView: NullView

  childViewContainer: '#sortable-graphs'

  template: viewTemplate

  constructor: (options) ->
    super
    @mergeOptions options, 'sConfs'
    @rootChannel = Backbone.Radio.channel('root')

  childViewOptions: ->
    return {
      sConfs:     @sConfs
    }
#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
