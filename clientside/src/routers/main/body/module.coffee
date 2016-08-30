#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
moment       = require 'moment'
Backbone     = require 'backbone'
Radio        = require 'backbone.radio'
Marionette   = require 'marionette'
GraphView    = require './graph/view'
Summary      = require './summary/module'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Model
#   Strength model used to fetch data of that exercises
#   such as the name and muscle type.
#-------------------------------------------------------------------------------

class Model extends Backbone.Model
  urlRoot:     '/api/wlogs'
  idAttribute: '_id'

#-------------------------------------------------------------------------------
# Collection
#-------------------------------------------------------------------------------

class Collection extends Backbone.Collection

  model: Model

  comparator: 'date'

  constructor: ->
    super
    @url = "/api/wlogs"

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  regions:
    modal:   '#body-modal-view'
    graph  : '#body-graph-view'
    summary: '#body-summary-view'

  events:

    'click #body-home': ->
      @rootChannel.request 'home'
      return

    'click .body-weights': ->
      @rootChannel.request 'weights'
      return

  constructor: (options) ->
    super
    @rootChannel = Backbone.Radio.channel('root')

    @channel = new Radio.channel(@cid)

    @summaryModel = new Summary.Model {},
      wLogs: @collection

    # When date is changed, update pageable collection.

    @listenTo @dateModel, 'change:date', =>
      @updatePageableCollection()
      return

  onShow: ->

    @showChildView 'graph', new GraphView
      collection: @collection

    @showChildView 'summary', new Summary.View
      model: @summaryModel
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
