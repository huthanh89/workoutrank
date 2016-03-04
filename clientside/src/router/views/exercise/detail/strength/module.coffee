#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Backbone     = require 'backbone'
Marionette   = require 'marionette'
InputView    = require './input/view'
TableView    = require './table/view'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Model
#-------------------------------------------------------------------------------

class Model extends Backbone.Model

  idAttribute: '_id'

  url:  '/api/exercise/strength'

  defaults:
    date: new Date()
    name:  ''
    type:  0
    note:  ''
    sets:  []
    count: 1

#-------------------------------------------------------------------------------
# Collection
#-------------------------------------------------------------------------------

class Collection extends Backbone.Collection
  url:  '/api/strength'
  model: Model

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView
  template: viewTemplate

  regions:
    input: '#exercise-strength-input-view'
    table: '#exercise-strength-table-view'

  onShow: ->
    @showChildView 'input', new InputView
      model: @model

    @showChildView 'table', new TableView()

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

exports.Model      = Model
exports.Collection = Collection
exports.View       = View

#-------------------------------------------------------------------------------
