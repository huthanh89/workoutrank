#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
Modal        = require './modal/module'
DateView     = require './date/view'
Table        = require './table/module'
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

  parse: (response) -> response

#-------------------------------------------------------------------------------
# Pageable Collection
#-------------------------------------------------------------------------------

class Collection extends Backbone.PageableCollection

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

  bindings:
    '#strength-header': 'name'

  events:

    'click #strength-back': ->
      @rootChannel.request 'strength'
      return

    'click #strength-log': ->
      @rootChannel.request 'strength:log', @strengthID
      return

    'click #strength-detail-add': ->
      @showChildView 'modal', new Modal.View
        collection: @collection
        model:      new Modal.Model(@model.attributes)
        date:       @model.get('date')
      return

  collectionEvents:
    sync: 'updateTable'

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
      @updateTable()
      return

  updateTable: ->
    models = @collection.fullCollection.filter (model) =>
      dateA = moment(model.get('date')).startOf('day')
      dateB = moment(@model.get('date')).startOf('day')
      return dateA.isSame(dateB)

    @tableCollection = new Backbone.Collection(models)

    @showTable()

    return

  onRender: ->
    @stickit()
    return

  onShow: ->
    @showChildView 'date', new DateView
      model: @model

    @showTable()
    return

  showTable: ->
    @showChildView 'table', new Table.View
      collection: @tableCollection
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Model      = Model
module.exports.Collection = Collection
module.exports.View       = View

#-------------------------------------------------------------------------------
