#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Color      = require 'color'
Highcharts = require 'highcharts'

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

rgb2hex = (red, green, blue) ->
  rgb = blue | green << 8 | red << 16
  return '#' + (0x1000000 + rgb).toString(16).slice(1)

colorHex = (color) -> rgb2hex(color[0], color[1], color[2])

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