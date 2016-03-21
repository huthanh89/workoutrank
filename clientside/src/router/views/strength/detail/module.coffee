#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
ModalView    = require './modal/view'
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

  state:
    currentPage: 1
    pageSize:    10

  comparator: (item) -> return -item.get('date')

  parseRecords: (response) -> response[0].strength

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView
  template: viewTemplate

  regions:
    modal: '#strength-modal-view'
    input: '#strength-input-view'
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

  onRender: ->
    @stickit()
    return

  onShow: ->

    console.log 'collection', @collection

    #@showChildView 'input', new InputView
    #  model:      @model
    #  collection: @collection

    ###
    @showChildView 'table', new TableView
      #collection: @collection
      collection: new Backbone.Collection()
      model: @model
###

    #@addWorkout()
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
