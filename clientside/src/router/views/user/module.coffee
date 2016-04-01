#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Backbone     = require 'backbone'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Model
#-------------------------------------------------------------------------------

class Model extends Backbone.Model
  defaults:
    name: ''

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

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

exports.Model      = Model
exports.Collection = Collection
exports.View       = View

#-------------------------------------------------------------------------------
