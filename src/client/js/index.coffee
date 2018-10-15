#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

$           = require 'jquery'
Highstock   = require 'highstock'
Application = require './application'

#-------------------------------------------------------------------------------
# Load in Bootstrap
#-------------------------------------------------------------------------------

require 'bootstrap'

#-------------------------------------------------------------------------------
# Set Highstock option for through out our project to change the date
# to GMT +0
#-------------------------------------------------------------------------------

Highstock.setOptions
  global: {
    useUTC: false
  }

#-------------------------------------------------------------------------------
# Google Analytics
#-------------------------------------------------------------------------------

((i, s, o, g, r, a, m) ->
  i['GoogleAnalyticsObject'] = r
  i[r] = i[r] or ->
    (i[r].q = i[r].q or []).push arguments
    return

  i[r].l = 1 * new Date
  a = s.createElement(o)
  m = s.getElementsByTagName(o)[0]
  a.async = 1
  a.src = g
  m.parentNode.insertBefore a, m
  return
) window, document, 'script', '//www.google-analytics.com/analytics.js', 'ga'
ga 'create', 'UA-74126093-1', 'auto'

#-------------------------------------------------------------------------------
# Starting point.
#-------------------------------------------------------------------------------

$ ->

  # When setting up everything for application is done, call start.

  new Application().start()

  return

#-------------------------------------------------------------------------------
