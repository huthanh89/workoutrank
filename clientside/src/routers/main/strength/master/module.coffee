#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Backbone     = require 'backbone'
Marionette   = require 'marionette'
Add          = require './add/module'
Table        = require './table/module'
FilterView   = require './filter/view'
PaginateView = require './paginate/view'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'backbone.paginator'
require 'bootstrap.paginate'

#-------------------------------------------------------------------------------
# Model
#   Keeps current state data of the page.
#   Here we maintain what muscle type is being chosen.
#-------------------------------------------------------------------------------

class Model extends Backbone.Model

  idAttribute: '_id'

  defaults:
    name: ''
    date: new Date()
    muscle:  0

#-------------------------------------------------------------------------------
# Main Collection
#   Clean collection used to fetch data from the server.
#   Refer back to this collection to filter and sort models.
#-------------------------------------------------------------------------------

class Collection extends Backbone.Collection

  url:  '/api/strengths'

  model: Model

  comparator: (item) -> return -item.get('date')

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

    'click #strength-remove-enable': ->
      @enableRemove = not @enableRemove
      @getRegion('table').currentView.enableRemove @enableRemove
      return

  modelEvents:
    'change:muscle': (model, value) ->
      @filterCollection(value)
      return

  collectionEvents:
    update: ->
      @getChildView('filter').filterCollection()
      return

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')
    @pageableCollection = new Table.Collection @collection.models

    @enableRemove = false

    @channel = Backbone.Radio.channel('channel')
    @channel.reply
      'add': =>
        @addWorkout()
        return

  onShow: ->

    @showChildView 'filter', new FilterView
      collection:         @collection
      pageableCollection: @pageableCollection

    @showChildView 'table', new Table.View
      collection: @pageableCollection
      channel:    @channel

    @showChildView 'page', new PaginateView
      collection: @pageableCollection

    return

  addWorkout: ->
    @showChildView 'modal', new Add.View
      collection: @collection
      model:      new Add.Model()
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
