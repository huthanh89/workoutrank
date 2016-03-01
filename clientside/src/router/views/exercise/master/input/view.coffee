#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'multiselect'
require 'backbone.stickit'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:
    name: '#exercise-name'
    type: '#exercise-type'

  bindings:
    '#exercise-name': 'name'
    '#exercise-type': 'type'

  events:

    'click #exercise-strength': ->
      return

    'click #exercise-endurance': ->
      return

    'click #exercise-flexibility': ->
      return

    'click #exercise-balance': ->
      return

    'submit': (event) ->
      event.preventDefault()
      @model.save {},
        success: =>
          @rootChannel.request('home')
          return
        error: ->
          console.log 'fail'
          return
      return

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')

  onRender: ->

    @ui.type.multiselect
      buttonWidth: '100%'
      buttonClass: 'multiselect-button'
    .multiselect 'dataprovider', [
      { value: 0, label: 'strength'    }
      { value: 1, label: 'cardio'      }
      { value: 2, label: 'flexibility' }
      { value: 3, label: 'balance'     }
    ]

    @stickit()

    return

  onDestroy: ->
    @ui.type.multiselect('destroy')
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
