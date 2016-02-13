#--------------------------------------------------------------------------------
# Imports
#--------------------------------------------------------------------------------

_           = require 'lodash'
Marionette  = require 'marionette'
Application = require 'src/application'
IndexView   = require './index/view'

#--------------------------------------------------------------------------------
# Router
#--------------------------------------------------------------------------------

class Router extends Marionette.AppRouter

  routes:
    '': 'index'

  index: ->
    Application.contentRegion.show(new IndexView())
    return

#--------------------------------------------------------------------------------
# Exports
#--------------------------------------------------------------------------------

module.exports = Router

#--------------------------------------------------------------------------------
