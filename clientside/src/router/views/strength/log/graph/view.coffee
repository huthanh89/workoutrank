#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

$            = require 'jquery'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
Highcharts   = require 'highcharts'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Series Data
#-------------------------------------------------------------------------------

series = (models) ->

  console.log models

  return {
    name: 'bob'
    data:  [7.0, 6.9, 9.5]
  }

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:
    chart: '#strength-graph-ui'

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')

  onShow: ->

    chart = new Highcharts.Chart

      chart:
        type:     'column'
        renderTo: @ui.chart[0]

      series: [
        series(@collection.models)
      ]

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
