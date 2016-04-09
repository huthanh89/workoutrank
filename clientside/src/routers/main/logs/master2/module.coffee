#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Backbone     = require 'backbone'
Marionette   = require 'marionette'
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
    name:    ''
    date:    new Date()
    muscle:  0

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

  onBeforeDestroy: ->
    @channel.reset()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Model = Model
module.exports.View  = View

#-------------------------------------------------------------------------------
