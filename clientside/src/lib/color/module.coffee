#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Color      = require 'color'
#rgbHex     = require 'rgb-hex'
Highcharts = require 'highcharts'

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

colorHex = (color) -> '#000000'
#  hexColor = rgbHex(color[0], color[1], color[2], color[3])
#  return "##{hexColor}"

indexColorRGB = (index) ->
  color = Color Highcharts.getOptions().colors[index]
  return color.rgb().array()

indexColorHex = (index) ->
  color = Color Highcharts.getOptions().colors[index]
  return colorHex(color.color)

opacityColor = (hex, percent) ->
  return Highcharts.Color(hex).setOpacity(percent).get('rgba')

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

exports.indexColorRGB = indexColorRGB
exports.indexColorHex = indexColorHex
exports.opacityColor  = opacityColor

#-------------------------------------------------------------------------------