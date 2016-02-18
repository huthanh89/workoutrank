#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

$            = require 'jquery'
_            = require 'lodash'
Marionette   = require 'marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'touchspin'
require 'multiselect'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:
    name: '#exercise-name'
    type: '#exercise-type'
    rep:  '#exercise-rep'
    set:  '#exercise-set'

  events:
    click: (event) ->
      console.log 'event'
      event.preventDefault()
      return

  onRender: ->

    @ui.rep.TouchSpin()
    @ui.set.TouchSpin()

    @ui.type.multiselect
      buttonWidth: '100%'
      buttonClass: 'multiselect-button'
    .multiselect 'dataprovider', [
      { value: 0, label: 'strength'    }
      { value: 1, label: 'cardio'      }
      { value: 2, label: 'flexibility' }
      { value: 3, label: 'balance'     }
    ]

    return

  onDestroy: ->
    @ui.type.multiselect('destroy')
    @ui.rep.TouchSpin('destroy')
    @ui.set.TouchSpin('destroy')
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
