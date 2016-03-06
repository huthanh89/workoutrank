#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Backbone     = require 'backbone'
Marionette   = require 'marionette'
InputView    = require './input/view'
TableView    = require './table/view'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView
  template: viewTemplate

  regions:
    input: '#exercise-strength-input-view'
    table: '#exercise-strength-table-view'

  events:
    'click #exercise-strength-back': ->
      @rootChannel.request('exercise')
      return

  modelEvents:
    'change:type': (model, value) ->
      @filterCollection(value)
      return

  constructor: ->
    super
    @rootChannel    = Backbone.Radio.channel('root')
    @fullCollection = @collection.fullCollection.clone()

  onShow: ->

    # Filter collection before showing table view.

    @filterCollection(@model.get('type'))

    @showChildView 'input', new InputView
      collection: @collection
      model:      @model

    @showChildView 'table', new TableView
      collection: @collection

    return

  # Fetch the latest collection then filter the collection by type.

  filterCollection: (type) ->
    @fullCollection.fetch
      success: =>
        models = @fullCollection.filter (model) -> model.get('type') is type
        @collection.fullCollection.reset models
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
