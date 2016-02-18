#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

$            = require 'jquery'
_            = require 'lodash'
Marionette   = require 'marionette'
Application  = require 'src/application'
viewTemplate = require './view.jade'

require 'touchspin'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:
    reps:      '#reps'
    touchspin: '#touchspin'

  events:
    click: (event) ->
      console.log 'event'
      event.preventDefault()
      return

  onRender: ->
    @ui.reps.TouchSpin()
    @ui.touchspin.TouchSpin()

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
