#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Backbone     = require 'backbone'
Marionette   = require 'marionette'
Add          = require './add/module'
Table        = require './table/module'
FilterView   = require './filter/view'
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
    name:   ''
    muscle: 0
    count:  0

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

  events:

    'click #strength-home': ->
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
    update: ->
      @getChildView('filter').filterCollection()
      return

  constructor: (options) ->
    super
    @mergeOptions options, 'sLogs'
    @rootChannel        = Backbone.Radio.channel('root')
    @channel            = Backbone.Radio.channel('channel')

    @pageableCollection = new Table.Collection @collection.models,
      sLogs: @sLogs

  onShow: ->

    # XXX Not sure why channel's reply will not work if placed
    # in constructor, so we put it here for now.

    @channel.reply

      'add': =>
        @addWorkout()
        return

      'edit:row': (model) =>
        @showChildView 'modal', new Add.View
          model: model
          edit: true

    @showChildView 'filter', new FilterView
      collection:         @collection
      pageableCollection: @pageableCollection

    @showChildView 'table', new Table.View
      collection: @pageableCollection
      channel:    @channel

    return

  addWorkout: ->
    @showChildView 'modal', new Add.View
      collection: @collection
      model:      new Add.Model()
    return

  onDestroy: ->
    @channel.reset()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Model      = Model
module.exports.Collection = Collection
module.exports.View       = View

#-------------------------------------------------------------------------------
