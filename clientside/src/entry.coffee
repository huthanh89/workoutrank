#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

$           = require 'jquery'
_           = require 'lodash'
Application = require './application'

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
# Starting point.
#-------------------------------------------------------------------------------

$ ->

  # When setting up everything for application is done, call start.
  Application.start()


#-------------------------------------------------------------------------------