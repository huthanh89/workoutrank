#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

$            = require 'jquery'
_            = require 'lodash'
moment       = require 'moment'
Backbone     = require 'backbone'
Radio        = require 'backbone.radio'
Marionette   = require 'backbone.marionette'
nullTemplate = require './null.pug'
itemTemplate = require './item.pug'
viewTemplate = require './view.pug'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'multiselect'
require 'backbone.stickit'

#-------------------------------------------------------------------------------
# Channels
#-------------------------------------------------------------------------------

rootChannel = Radio.channel('root')

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

  comparator: (item) -> return -item.get('date')

  parse: (models, options) ->

    sLogs  = options.sLogs.models
    sConfs = models

    _.each sConfs, (sConf) ->
      models = _.filter sLogs, (sLog) ->
        return sLog.get('exercise') is sConf.get('_id')

      sConf.set('count', models.length)

      latest = _.maxBy models, (model) -> model.get('date')

      sConf.set 'updated', if latest then latest.get('date') else null

      return

#-------------------------------------------------------------------------------
# Null View
#-------------------------------------------------------------------------------

class NullView extends Marionette.View
  tagName: 'tr'
  template: nullTemplate

  constructor: (options) ->
    super(options)
    @mergeOptions options, [
      'channel'
    ]

  events:
    click: ->
      @channel.request 'add'
      return

#-------------------------------------------------------------------------------
# ItemView
#-------------------------------------------------------------------------------

class ItemView extends Marionette.View

  tagName: 'tr'

  template: itemTemplate

  ui:
    td: '.strength-table-td'

  bindings:

    '.strength-table-td-name': 'name'

    '.strength-table-td-count':
      observe: 'count'
      onGet: (value) -> value

    '.strength-table-td-updated':
      observe: 'updated'
      onGet: (value) -> if value then moment(value).from(moment()) else 'None'

  events:
    'click': ->
      rootChannel.request 'strength:detail', @model.id
      return

  constructor: (options) ->
    super(options)
    @mergeOptions options, [
      'channel'
    ]

  onRender: ->
    @stickit()
    return

  onAttach: ->
    @updateProgressBar(@model.get('count'))
    return

  updateProgressBar: (value) ->

    bar = $(@el).find('.progress-bar-striped')

    if value > 0

      average = @channel.request('get:average')
      percent = _.round((value/average * 100), 2)
      percent = _.clamp percent, 0, 100

      # Choose the color.

      if(0 < percent <= 33) then bar.addClass('bg-danger')
      else if(33 < percent <= 66) then bar.addClass('bg-warning')
      else bar.addClass('bg-success')

      # Update width size.

      bar
      .css('width', "#{percent}%")
      .addClass('progress-bar')

    else
      bar.css('width', '0%')

    return

  onBeforeDestroy: ->
    @unstickit()
    return

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.CollectionView

  childViewContainer: 'tbody'

  emptyView: NullView

  childView: ItemView

  template: viewTemplate

  ui:
    table:  '#strength-table'
    header: '.strength-table-th'

  constructor: (options) ->
    super(options)
    @mergeOptions options, [
      'channel'
    ]

    @channel.reply
      'get:average': => _.meanBy(@collection.models, (model) -> model.get('count'))

  childViewOptions: ->
    return {
      channel: @channel
    }

  onAttach: ->
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Collection = Collection
module.exports.View       = View

#-------------------------------------------------------------------------------
