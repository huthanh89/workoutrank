#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
Modal        = require './modal/module'
DateView     = require './date/view'
Table        = require './table/module'
PaginateView = require './paginate/view'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'datepicker'

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

  mode: 'client'

  constructor: (attributes, options) ->
    super
    @url = "/api/strengths/#{options.id}/log"

  state:
    currentPage: 1
    pageSize:    10

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  regions:
    modal: '#strength-modal-view'
    date:  '#strength-date-view'
    table: '#strength-table-view'
    page:  '#strength-paginate-view'

  bindings:
    '#strength-header': 'name'

  events:

    'click #strength-back': ->
      @rootChannel.request 'strength'
      return

    'click #strength-log': ->
      @rootChannel.request 'strength:log', @strengthID
      return

    'click #strength-detail-add': 'addWorkout'

  collectionEvents:
    'sync update': 'updatePageableCollection'

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

    @channel = Backbone.Radio.channel('channel')

    @channel.reply
      'add': =>
        @addWorkout()
        return

    @pageableCollection = new Table.Collection @collection.models

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

    @showChildView 'page', new PaginateView
      collection: @pageableCollection

    return

  addWorkout: ->
    @showChildView 'modal', new Modal.View
      collection: @collection
      model:      new Modal.Model _.omit(@model.attributes, '_id')
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
