#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
moment       = require 'moment'
Backbone     = require 'backbone'
Radio        = require 'backbone.radio'
Marionette   = require 'marionette'
Add          = require './add/module'
Edit         = require './edit/module'
DateView     = require './date/view'
Table        = require './table/module'
Summary      = require './summary/module'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Model
#   Strength model used to fetch data of that exercises
#   such as the name and muscle type.
#-------------------------------------------------------------------------------

class Model extends Backbone.Model

  urlRoot: '/api/strengths'

  idAttribute: '_id'

#-------------------------------------------------------------------------------
# Collection
#-------------------------------------------------------------------------------

class Collection extends Backbone.Collection

  model: Model

  constructor: (attributes, options) ->
    super
    @url = "/api/strengths/#{options.id}/log"

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  regions:
    modal:   '#strength-modal-view'
    date:    '#strength-date-view'
    table:   '#strength-table-view'
    summary: '#strength-summary-view'
    chart:   '#strength-chart-view'

  bindings:
    '#strength-title': 'name'

  events:

    'click #strength-home': ->
      @rootChannel.request 'home'
      return

    'click #strength-journals': ->
      @rootChannel.request 'strengths'
      return

    'click #strength-detail-add': ->
      @channel.request 'add'
      return

    'click #strength-detail-edit': ->
      @showChildView 'modal', new Edit.View
        model:   @model
        summary: @summaryModel
      return

    'click .strength-graph-detail': ->
      @rootChannel.request 'log:detail', @model.get('exercise')
      return

  collectionEvents:
    'sync update': ->
      @updatePageableCollection()
      @summaryModel.update(@model, @collection)
      return

  modelEvents:
    sync: (model) ->
      @summaryModel.update(@model, @collection)
      return

  constructor: (options) ->
    super
    @rootChannel = Backbone.Radio.channel('root')
    @mergeOptions options, 'strengthID'

    attributes = _.chain @model.attributes
      .extend
        date:     new Date()
        exercise: @model.get('_id')
      .omit '_id'
      .value()

    @channel = new Radio.channel('strength:detail')

    @channel.reply
      'add': =>
        @addWorkout
          date: @model.get('date')
        return

    @pageableCollection = new Table.Collection @collection.models

    @summaryModel = new Summary.Model {},
      sConf: @model
      sLogs: @collection

    # When date is changed, update pageable collection.

    @listenTo @model, 'change:date', =>
      @updatePageableCollection()
      return

  onRender: ->
    @stickit()
    return

  onShow: ->

    @showChildView 'date', new DateView
      model: @model

    @showChildView 'table', new Table.View
      collection: @pageableCollection
      channel:    @channel

    @showChildView 'summary', new Summary.View
      model: @summaryModel

    return

  addWorkout: ->
    @showChildView 'modal', new Add.View
      collection: @collection
      model:      new Add.Model _.omit(@model.attributes, '_id')
      date:       @model.get('date')
    return

  updatePageableCollection: ->
    models = @collection.filter (model) =>
      dateA = moment(model.get('date')).startOf('day')
      dateB = moment(@model.get('date')).startOf('day')
      return dateA.isSame(dateB)
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
