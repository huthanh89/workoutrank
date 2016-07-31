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
require 'datatable'

#-------------------------------------------------------------------------------
# Pageable Collection
#   Page collection to paginate table. Used specifically in client mode.
#-------------------------------------------------------------------------------

class Collection extends Backbone.PageableCollection

  url:  '/api/strengths'

  mode: 'client'

  state:
    currentPage: 1
    pageSize:    10

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

    '.strength-table-td-muscle':
      observe: 'muscle'
      onGet: (value) -> _.find(Data.Muscles, value: value).label

  events:
    'click td:nth-child(1)': ->
      @rootChannel.request 'strength:detail', @model.id
      return
    'click td:nth-child(2)': ->
      @rootChannel.request 'strength:detail', @model.id
      return
    'click td:nth-child(3)': ->
      @rootChannel.request 'strength:detail', @model.id
      return

    'click td:nth-child(4)': ->
      @model.destroy
        wait: true
      return

    'click td:nth-child(5)': ->
      @channel.request 'edit:row', @model
      return

  constructor: (options) ->
    super
    @mergeOptions options, [
      'channel'
      'sLogs'
    ]
    @rootChannel = Backbone.Radio.channel('root')
    @sLog = @sLogs.get(@model.id)

  onRender: ->
    @ui.count.text @sLog.get('repData').length
    @stickit()
    return

  enableRemove: (enable) ->
    if enable then @ui.td.removeClass('hidden') else @ui.td.addClass('hidden')
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
      'sLogs'
    ]

  childViewOptions: ->
    return {
      channel: @channel
      sLogs:   @sLogs
    }

  onShow: ->
    @table = @ui.table.DataTable
      scrollX: true
    return

  enableRemove: (enable) ->
    @children.call 'enableRemove', enable
    if enable then @ui.header.removeClass('hidden') else @ui.header.addClass('hidden')

    @table.draw()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Collection = Collection
module.exports.View       = View

#-------------------------------------------------------------------------------
