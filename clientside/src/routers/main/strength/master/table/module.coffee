#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

$            = require 'jquery'
_            = require 'lodash'
moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
Data         = require '../../data/module'
nullTemplate = require './null.jade'
itemTemplate = require './item.jade'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'multiselect'
require 'backbone.stickit'

#-------------------------------------------------------------------------------
# Pageable models
#-------------------------------------------------------------------------------

class Model extends Backbone.Model
  defaults:
    name:   ''
    muscle: []
    count:  0

#-------------------------------------------------------------------------------
# Collection
#   collection to paginate table. Used specifically in client mode.
#-------------------------------------------------------------------------------

class Collection extends Backbone.Collection

  url:  '/api/strengths'

  model: Model

  state:
    currentPage: 1
    pageSize:    10

  constructor: (models, options) ->
    super
    _.each models, (model) ->
      sLog = options.sLogs.get(model.id)
      if sLog
        model.set('count', sLog.get('repData').length)
      return

  comparator: (item) -> return -item.get('date')

#-------------------------------------------------------------------------------
# Null View
#-------------------------------------------------------------------------------

class NullView extends Marionette.ItemView
  tagName: 'tr'
  template: nullTemplate

  constructor: (options) ->
    super
    @mergeOptions options, 'channel'

  events:
    click: -> @channel.request 'add'

#-------------------------------------------------------------------------------
# ItemView
#-------------------------------------------------------------------------------

class ItemView extends Marionette.ItemView

  tagName: 'tr'

  template: itemTemplate

  ui:
    td:    '.strength-table-td'
    count: '.strength-table-td-count'

  bindings:

    '.strength-table-td-name': 'name'

    '.strength-table-td-count':
      observe: 'count'
      onGet: (value) ->
        #@updateProgressBar(value)
        return value

    '.strength-table-td-muscle':
      observe: 'muscle'
      onGet: (values) ->
        result = []
        for value in values
          result.push _.find(Data.Muscles, value: value).label
        return _.truncate result.toString(),
          length:    20,
          separator: ' '

  events:
    'click': ->
      @rootChannel.request 'strength:detail', @model.id
      return

  constructor: (options) ->
    super
    @mergeOptions options, 'channel'
    @rootChannel = Backbone.Radio.channel('root')

  onRender: ->
    @stickit()
    return

  onShow: ->
    @updateProgressBar(@model.get('count'))
    return

  updateProgressBar: (value) ->
    max     = @channel.request('get:max')
    percent = _.round((value/max * 100), 2)

    $(@el).find('.progress-bar').css('width', "#{percent}%")
    return

  onBeforeDestroy: ->
    @unstickit()
    return

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.CompositeView

  childViewContainer: 'tbody'

  emptyView: NullView

  childView: ItemView

  template: viewTemplate

  ui:
    table:  '#strength-table'
    header: '.strength-table-th'

  constructor: (options) ->
    super
    @mergeOptions options, [
      'channel'
    ]

    @channel.reply
      'get:max': => _.maxBy(@collection.models, (model) -> model.get('count')).get('count')

  childViewOptions: ->
    return {
      channel: @channel
    }

  onShow: ->
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Collection = Collection
module.exports.View       = View

#-------------------------------------------------------------------------------
