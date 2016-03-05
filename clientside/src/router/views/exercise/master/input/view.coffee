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
    'submit': (event) ->
      event.preventDefault()
      @model.save {},
        success: =>
          #@rootChannel.request('home')
          @collection.add(@model)
          @render()
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
      enableFiltering: true
      buttonWidth:    '100%'
      buttonClass:    'btn btn-info'
    .multiselect 'dataprovider', [
      { value: 0, label: 'Strength'    }
      { value: 1, label: 'Cardio'      }
      { value: 2, label: 'Flexibility' }
      { value: 3, label: 'Balance'     }
    ]

    @stickit()

    return

  onBeforeDestroy: ->
    @ui.type.multiselect('destroy')
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
