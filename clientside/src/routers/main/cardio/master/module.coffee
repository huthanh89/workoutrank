#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

swal         = require 'sweetalert'
Backbone     = require 'backbone'
Marionette   = require 'backbone.marionette'
Add          = require './add/module'
Table        = require './table/module'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'backbone.paginator'
require 'bootstrap.paginate'

#-------------------------------------------------------------------------------
# Cardio Config Model
#-------------------------------------------------------------------------------

class CConf extends Backbone.Model
  idAttribute: '_id'

#-------------------------------------------------------------------------------
# Cardio Config Collection
#-------------------------------------------------------------------------------

class CConfs extends Backbone.Collection

  url: '/api/cardios'
  model: CConf

#-------------------------------------------------------------------------------
# Cardio Log Collection
#-------------------------------------------------------------------------------

class CLogs extends Backbone.Collection

  url: '/api/clogs'

#-------------------------------------------------------------------------------
# Model
#-------------------------------------------------------------------------------

class Model extends Backbone.Model

  idAttribute: '_id'

  defaults:
    name:   ''
    count:  0

#-------------------------------------------------------------------------------
# Main Collection
#   Clean collection used to fetch data from the server.
#   Refer back to this collection to filter and sort models.
#-------------------------------------------------------------------------------

class Collection extends Backbone.Collection

  url:  '/api/cardios'

  model: Model

  comparator: (item) -> return -item.get('date')

  parse: (models, options) ->

    for cConf in options.cConfs

      models = _.filter options.cLogs, (model) ->
        return model.get('exerciseID') is cConf.get('_id')

      model = _.maxBy models, (model) -> model.get('created')

      cConf.set 'updated', if model then model.get('created') else null

      cConf.set 'count', models.length

    return options.cConfs

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  ui:
    add: '#cardio-add'

  regions:
    modal: '#cardio-modal-view'
    table: '#cardio-table-view'

  events:

    'click #cardio-help': ->
      swal
        title: 'Instructions'
        text:  'Click "Add Exercise" button to add a new workout. Click on any item on the table to start your workout.'
      return

    'click #cardio-home': ->
      @rootChannel.request 'home'
      return

    'click #cardio-add': ->
      @addWorkout()
      return

  constructor: (options) ->
    super
    @mergeOptions options, [
      'cLogs'
    ]
    @rootChannel = Backbone.Radio.channel('root')
    @channel     = new Backbone.Radio.channel(@cid)

    @channel.reply
      'add': =>
        @addWorkout()
        return

  onAttach: ->

    @showChildView 'table', new Table.View
      collection: @collection
      channel:    @channel

    if @collection.length is 0
      @channel.request 'add'

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
module.exports.CConfs     = CConfs
module.exports.CLogs      = CLogs
module.exports.View       = View

#-------------------------------------------------------------------------------
