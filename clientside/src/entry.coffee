#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

$           = require 'jquery'
_           = require 'lodash'
Highstock   = require 'highstock'
Application = require './application'

#-------------------------------------------------------------------------------
# Set Highstock option for through out our project to change the date
# to GMT +0
#-------------------------------------------------------------------------------

Highstock.setOptions
  global: {
    useUTC: false
  }

#-------------------------------------------------------------------------------
# Hacks and workaround.
#
#   Bootstrap jquery plugins expect jQuery to be on 'window' or 'this' object.
#
#-------------------------------------------------------------------------------

window.jQuery = window.$ = require 'jquery'

# Require all plugins that requires jquery.
require 'mmenu'
require 'bootstrap'

# Console out if bootstrap is not working.
unless $().modal
  console.log 'bootstrap is not working.'

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

  Application.start()

  return

#-------------------------------------------------------------------------------