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
  url:  '/api/exercise'
  defaults:
    name: ''
    type: 0
    note: ''
    date: new Date()

#-------------------------------------------------------------------------------
# Collection
#-------------------------------------------------------------------------------

class Collection extends Backbone.Collection
  url:  '/api/exercise'
  model: Model

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

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')
    @channel =     Backbone.Radio.channel('view')
    @channel.reply 'hey', -> 'bobsdf'

  onShow: ->

    @showChildView 'input', new InputView
      collection: @collection
      model:       new Model()

    @showChildView 'table', new TableView
      collection: @collection

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
