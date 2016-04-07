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

  url: '/api/exercise'

  idAttribute: '_id'

  defaults:
    user:     ''
    strength: []

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  ui:
    strength: '#exercise-strength'

  regions:
    input: '#exercise-input-view'
    table: '#exercise-table-view'

  events:
    'click #exercise-back-home': ->
      @rootChannel.request('home')
      return

  modelEvents:
    'change:type': (model, value) ->
      @filterCollection(value)
      return

  constructor: ->
    super
    @rootChannel    = Backbone.Radio.channel('root')
    @channel        = Backbone.Radio.channel('channel')
    @fullCollection = @collection.fullCollection.clone()

  onShow: ->

    # Filter collection before showing table view.

    @filterCollection(@model.get('type'))

    @showChildView 'input', new InputView
      collection: @collection
      model:      @model


    #@showChildView 'table', new TableView
    #  collection: @collection

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

module.exports.Model = Model
module.exports.View  = View

#-------------------------------------------------------------------------------