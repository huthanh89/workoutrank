#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Backbone     = require 'backbone'
Marionette   = require 'marionette'
ModalView    = require './modal/view'
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
#-------------------------------------------------------------------------------

class Collection extends Backbone.Collection

  url:  '/api/exercise'

  model: Model

  comparator: (item) -> return -item.get('date')

  parse: (response) -> response.strength

#-------------------------------------------------------------------------------
# Pageable Collection
#-------------------------------------------------------------------------------

class PageableCollection extends Backbone.PageableCollection

  url:  '/api/exercise'

  model: Model

  mode: 'client'

  state:
    currentPage: 1
    pageSize:    2

  comparator: (item) -> return -item.get('date')

  parseRecords: (response) -> response[0].strength

class Test extends Marionette.ItemView
  template: _.template 'hello world'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  regions:
    modal: '#strength-modal-view'
    table: '#strength-table-view'
    page:  '#strength-paginate-view'

  events:
    'click #strength-back': ->
      @rootChannel.request('exercise')
      return

    'click #strength-add': ->
      @showChildView 'modal', new ModalView
        collection: @collection
        model:      @model
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
      'hey': ->
        console.log 'hey'
        return

  onShow: ->

    # Filter collection before showing table view.

    @filterCollection(@model.get('muscle'))

    @showChildView 'table', new TableView
      collection: @pageableCollection

    @showChildView 'page', new PaginateView
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
