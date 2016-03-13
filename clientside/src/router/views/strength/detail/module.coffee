#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
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
# Collection
#-------------------------------------------------------------------------------

class Collection extends Backbone.PageableCollection

  url:  '/api/strength'

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

  regions:
    input: '#strength-input-view'
    table: '#strength-table-view'

  events:
    'click #strength-back': ->
      @rootChannel.request 'strength'
      return

    'click #strength-log': ->
      @rootChannel.request 'strength:log', @strengthID
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

    @showChildView 'input', new InputView
      model:      @model
      collection: @collection

    ###
    @showChildView 'table', new TableView
      #collection: @collection
      collection: new Backbone.Collection()
      model: @model
###
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Model      = Model
module.exports.Collection = Collection
module.exports.View       = View

#-------------------------------------------------------------------------------
