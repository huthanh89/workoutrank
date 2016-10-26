#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

$            = require 'jquery'
_            = require 'lodash'
moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
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

  idAttribute: '_id'

  defaults:
    name:   ''
    muscle: []
    count:  0

#-------------------------------------------------------------------------------
# Collection
#-------------------------------------------------------------------------------

class Collection extends Backbone.Collection

  url:  '/api/cardios'

  model: Model

  constructor: (models, options) ->
    super
    _.each models, (model) ->
      cLog = options.cLogs.get(model.id)
      if cLog
        model.set('count', cLog.length)
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
    td: '.cardio-table-td'

  bindings:

    '.cardio-table-td-name': 'name'

    '.cardio-table-td-count':
      observe: 'count'
      onGet: (value) -> value

  events:
    'click': ->
      @rootChannel.request 'cardio:detail', @model.get('_id')
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
    table:  '#cardio-table'
    header: '.cardio-table-th'

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
