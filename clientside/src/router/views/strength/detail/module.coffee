#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
ModalView    = require './modal/view'
DateView     = require './date/view'
TableView    = require './table/view'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'backbone.paginator'
require 'datepicker'

#-------------------------------------------------------------------------------
# Model
#-------------------------------------------------------------------------------

class Model extends Backbone.Model

  idAttribute: '_id'

  constructor: (attributes, options) ->
    super
    if options?.id
      @url = "/api/strength/#{options.id}"
    else
      @url = '/api/strength'

  defaults:
    count:   1
    session: []

  parse: (response) -> response

#-------------------------------------------------------------------------------
# Pageable Collection
#-------------------------------------------------------------------------------

class Collection extends Backbone.PageableCollection

  url:  '/api/strength/log'

  model: Model

  mode: 'client'

  constructor: (attributes, options) ->
    super
    @url = "/api/strength/#{options.id}/log"

  state:
    currentPage: 1
    pageSize:    10

  comparator: (item) -> return -item.get('date')

  parseRecords: (response) ->
    @date   = response.date
    @muscle = response.muscle
    @name   = response.name
    return response.log

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  regions:
    modal: '#strength-modal-view'
    date:  '#strength-date-view'
    table: '#strength-table-view'

  events:

    'click #strength-back': ->
      @rootChannel.request 'strength'
      return

    'click #strength-log': ->
      @rootChannel.request 'strength:log', @strengthID
      return

    'click #strength-detail-add': ->
      @addWorkout()
      return

  bindings:
    '#strength-header': 'name'

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

    @model = new Model attributes

    @tableCollection = @collection

    @listenTo @model, 'change:date', =>
      models = @collection.fullCollection.filter (model) =>
        dateA = moment(model.get('date')).startOf('day')
        dateB = moment(@model.get('date')).startOf('day')
        return dateA.isSame(dateB)

      sessions = []
      index    = 0

      for model in models
        for session, index in model.get('session')

          index = index + 1
          console.log index

          sessions.push {
            set:    index
            rep:    session.rep
            weight: session.weight
          }

      @tableCollection = new Backbone.Collection(sessions)

      @showChildView 'table', new TableView
        collection: @tableCollection

      return

  onRender: ->
    @stickit()
    return

  onShow: ->

    @showChildView 'date', new DateView
      model: @model

    @showChildView 'table', new TableView
      collection: @tableCollection

    return

  addWorkout: ->
    @showChildView 'modal', new ModalView
      collection: @collection
      model:      @model
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Model      = Model
module.exports.Collection = Collection
module.exports.View       = View

#-------------------------------------------------------------------------------
