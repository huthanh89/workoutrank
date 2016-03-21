#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Backbone     = require 'backbone'
Marionette   = require 'marionette'
ModalView    = require './modal/view'
FilterView   = require './filter/view'
TableView    = require './table/view'
PaginateView = require './paginate/view'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'backbone.paginator'
require 'bootstrap.paginate'

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
#   Main collection used to fetch data from the server.
#-------------------------------------------------------------------------------

class Collection extends Backbone.Collection

  url:  '/api/exercise'

  model: Model

  comparator: (item) -> return -item.get('date')

  parse: (response) -> response.strength

#-------------------------------------------------------------------------------
# Pageable Collection
#   Page collection to paginate table. Used specifically in client mode.
#-------------------------------------------------------------------------------

class PageableCollection extends Backbone.PageableCollection

  url:  '/api/exercise'

  model: Model

  mode: 'client'

  state:
    currentPage: 1
    pageSize:    5

  comparator: (item) -> return -item.get('date')

  parseRecords: (response) -> response[0].strength

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  regions:
    modal:  '#strength-modal-view'
    filter: '#strength-filter-view'
    table:  '#strength-table-view'
    page:   '#strength-paginate-view'

  events:
    'click #strength-back': ->
      @rootChannel.request 'home'
      return

    'click #strength-add': ->
      @addWorkout()
      return

  modelEvents:
    'change:muscle': (model, value) ->
      @filterCollection(value)
      return

  collectionEvents:
    sync: ->
      @filterCollection(@model.get('muscle'))
      return

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')
    @pageableCollection = new PageableCollection @collection.models
    @channel = Backbone.Radio.channel('channel')

    @channel.reply
      'add': =>
        @addWorkout()
        return

  onShow: ->

    # Filter collection before showing table view.

    @filterCollection(@model.get('muscle'))

    @showChildView 'filter', new FilterView
      collection: @collection
      model:      @model

    @showChildView 'table', new TableView
      collection: @pageableCollection
      channel:    @channel

    @showChildView 'page', new PaginateView
      collection: @pageableCollection

    return

  addWorkout: ->
    @showChildView 'modal', new ModalView
      collection: @collection
      model:      @model
    return

  # Fetch the latest collection then filter the collection by muscle.

  filterCollection: (muscle) ->
    models = @collection.filter (model) -> model.get('muscle') is muscle
    @pageableCollection.fullCollection.reset models
    return

  onBeforeDestroy: ->
    @channel.reset()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Model      = Model
module.exports.Collection = Collection
module.exports.View       = View

#-------------------------------------------------------------------------------
