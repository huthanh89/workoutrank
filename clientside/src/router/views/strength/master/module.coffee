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

  defaults:
    date: new Date()
    name:    ''
    muscle:  0
    note:    ''

#-------------------------------------------------------------------------------
# Collection
#-------------------------------------------------------------------------------

class Collection extends Backbone.Collection

  url:  '/api/exercise'

  model: Model

  comparator: (item) -> return -item.get('date')

  parse: (response) -> response[0].strength

#-------------------------------------------------------------------------------
# Collection
#-------------------------------------------------------------------------------

class PageableCollection extends Backbone.PageableCollection

  url:  '/api/exercise'

  model: Model

  mode: 'client'

  state:
    currentPage: 1
    pageSize:    10

  comparator: (item) -> return -item.get('date')

  parseRecords: (response) -> response[0].strength

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView
  template: viewTemplate

  regions:
    input: '#strength-input-view'
    table: '#strength-table-view'

  events:
    'click #strength-back': ->
      @rootChannel.request('exercise')
      return

  collectionEvents:
    sync: ->
      @filterCollection(@model.get('muscle'))
      return

  modelEvents:
    'change:muscle': (model, value) ->
      @filterCollection(value)
      return

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')
    @pageableCollection = new PageableCollection @collection.models

  onShow: ->

    # Filter collection before showing table view.

    @filterCollection(@model.get('muscle'))

    @showChildView 'input', new InputView
      collection: @collection
      model:      @model

    @showChildView 'table', new TableView
      collection: @pageableCollection

    return

  # Fetch the latest collection then filter the collection by muscle.

  filterCollection: (muscle) ->
    models = @collection.filter (model) -> model.get('muscle') is muscle
    @pageableCollection.fullCollection.reset models
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Model      = Model
module.exports.Collection = Collection
module.exports.View       = View

#-------------------------------------------------------------------------------
