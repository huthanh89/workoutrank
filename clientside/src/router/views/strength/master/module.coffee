#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Backbone     = require 'backbone'
Marionette   = require 'marionette'
InputView    = require './input/view'
TableView    = require './table/view'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'backbone.paginator'

#-------------------------------------------------------------------------------
# Model
#-------------------------------------------------------------------------------

class Model extends Backbone.Model

  idAttribute: '_id'

  url:  '/api/exercise/strength'

  defaults:
    date: new Date()
    name:   ''
    muscle: 0
    note:   ''
    sets:   []
    count:  1

#-------------------------------------------------------------------------------
# Collection
#-------------------------------------------------------------------------------

class Collection extends Backbone.PageableCollection

  url:  '/api/exercise/strength'

  model: Model

  mode: 'client'

  state:
    currentPage: 1
    pageSize:    10

  comparator: (item) -> return -item.get('date')

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
    'change:muscle': (model, value) ->
      @filterCollection(value)
      return

  constructor: ->
    super
    @rootChannel    = Backbone.Radio.channel('root')
    @fullCollection = @collection.fullCollection.clone()

  onShow: ->

    # Filter collection before showing table view.

    @filterCollection(@model.get('muscle'))

    @showChildView 'input', new InputView
      collection: @collection
      model:      @model

    @showChildView 'table', new TableView
      collection: @collection

    return

  # Fetch the latest collection then filter the collection by muscle.

  filterCollection: (muscle) ->
    @fullCollection.fetch
      success: =>
        models = @fullCollection.filter (model) -> model.get('muscle') is muscle
        @collection.fullCollection.reset models
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Model      = Model
module.exports.Collection = Collection
module.exports.View       = View

#-------------------------------------------------------------------------------
