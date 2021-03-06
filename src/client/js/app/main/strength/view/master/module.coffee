#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

swal         = require 'sweetalert'
Backbone     = require 'backbone'
Radio        = require 'backbone.radio'
Marionette   = require 'backbone.marionette'
Add          = require './add/module'
Table        = require './table/module'
FilterView   = require './filter/view'
viewTemplate = require './view.pug'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'backbone.paginator'
require 'bootstrap.paginate'

#-------------------------------------------------------------------------------
# Channels
#-------------------------------------------------------------------------------

rootChannel = Radio.channel('root')
userChannel = Radio.channel('user')

#-------------------------------------------------------------------------------
# Model
#   Keeps current state data of the page.
#   Here we maintain what muscle type is being chosen.
#-------------------------------------------------------------------------------

class Model extends Backbone.Model

  idAttribute: '_id'

  defaults:
    name:   ''
    muscle: 0
    count:  0

#-------------------------------------------------------------------------------
# Main Collection
#   Clean collection used to fetch data from the server.
#   Refer back to this collection to filter and sort models.
#-------------------------------------------------------------------------------

class Collection extends Backbone.Collection

  url: '/api/strengths'

  model: Model

  comparator: (item) -> return -item.get('date')

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.View

  template: viewTemplate

  ui:
    add: '#strength-add'

  regions:
    modal:  '#strength-modal-view'
    filter: '#strength-filter-view'
    table:  '#strength-table-view'

  events:

    'click #strength-help': ->
      swal
        title: 'Instructions'
        text:  'Click "Add Exercise" button to add a new exercise. Click on any item on the table to start your exercise.'
      return

    'click #strength-home': ->
      rootChannel.request 'home'
      return

    'click #strength-add': ->
      @addWorkout()
      return

  modelEvents:
    'change:muscle': (model, value) ->
      @filterCollection(value)
      return

  collectionEvents:
    update: ->
      @getChildView('filter').filterCollection()
      return

  constructor: (options) ->
    super(options)
    @mergeOptions options, [
      'sLogs'
      'muscle'
    ]
    @channel = new Backbone.Radio.channel(@cid)
    @isOwner = userChannel.request 'isOwner'

    @channel.reply

      'add': =>
        @addWorkout()
        return

      'edit:row': (model) =>
        @showChildView 'modal', new Add.View
          model: model
          edit: true

    @tableCollection = new Table.Collection @collection.models,
      sLogs: @sLogs
      parse: true

    if @muscle?
      models = @collection.filter (model) =>
        return parseInt(model.get('muscle'), 10) is parseInt(@muscle, 10)
      @tableCollection.reset models

  onAttach: ->
    @showChildView 'filter', new FilterView
      collection:      @collection
      tableCollection: @tableCollection
      muscle:          @muscle

    @showChildView 'table', new Table.View
      collection: @tableCollection
      channel:    @channel
      muscle:     @muscle

    if @collection.length is 0
      @channel.request 'add'

    @ui.add.hide() unless userChannel.request 'isOwner'

    return

  addWorkout: ->
    @showChildView 'modal', new Add.View
      collection: @collection
      model:      new Add.Model()
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
