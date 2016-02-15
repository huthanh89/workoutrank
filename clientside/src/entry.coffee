#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

$           = require 'jquery'
_           = require 'lodash'
Radio       = require 'backbone.radio'
Backbone    = require 'backbone'
Marionette  = require 'marionette'
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

#_.extend(App, Radio.Commands);

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