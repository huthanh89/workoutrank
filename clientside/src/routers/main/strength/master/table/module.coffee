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

  comparator: (item) -> return -item.get('date')

  parse: (models, options) ->

    sLogs  = options.sLogs.models
    sConfs = models

    _.each sConfs, (sConf) ->
      models = _.filter sLogs, (sLog) ->
        return sLog.get('exercise') is sConf.get('_id')

      sConf.set('count', models.length)

      return

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
    td: '.strength-table-td'

  bindings:

    '.strength-table-td-name': 'name'

    '.strength-table-td-count':
      observe: 'count'
      onGet: (value) -> value

    '.strength-table-td-muscle':
      observe: 'muscle'
      onGet: (values) ->
        if values.length > 0
          result = []
          for value in values
            result.push _.find(Data.Muscles, value: value).label
          return _.truncate result.toString(),
            length:    20,
            separator: ' '
        else
          return '---'

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

    bar = $(@el).find('.progress-bar-striped')

    if value > 0

      average = @channel.request('get:average')
      percent = _.round((value/average * 100), 2)
      percent = _.clamp percent, 0, 100

      # Choose the color.

      if(0 < percent <= 33) then bar.addClass('progress-bar-danger')
      else if(33 < percent <= 66) then bar.addClass('progress-bar-warning')
      else bar.addClass('progress-bar-info')

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
      'get:average': => _.meanBy(@collection.models, (model) -> model.get('count'))

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
