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
  url:  '/api/exercise'
  defaults:
    name: ''
    type: 0
    note: ''
    date: new Date()

#-------------------------------------------------------------------------------
# Collection
#-------------------------------------------------------------------------------

class Collection extends Backbone.PageableCollection

  url:  '/api/exercise'

  model: Model

  mode: 'client'

  state:
    currentPage: 1
    pageSize:    10

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

  collectionEvents:
    'sync': ->
      @showInputView()
      @showTableView()
      return

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')
    @channel     = Backbone.Radio.channel('channel')
    @type        = 0

    @channel.reply 'type', (type) =>
      @type = type
      return

    @fullCollection = @collection.fullCollection

  # Show table view, filtered by type.

  showTableView: ->
    @showChildView 'table', new TableView
      collection: @collection
    ###
    console.log @type

    models = @fullCollection.filter (model) =>
      return model.get('type') is @type

    @showChildView 'table', new TableView
      collection: new Collection models

###
    return

  # Show input view

  showInputView: ->

    model = new Model
      type: @type

    @input.show new InputView
      collection: @collection
      model:      model
      channel:    @channel
      type:       @type
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
