#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
Pageable     = require 'src/behavior/pageable/module'
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

  parseRecords: (response) -> response[0].strength

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

  bindings:

    '.strength-table-td-name': 'name'
    '.strength-table-td-muscle': 'muscle'

    '.strength-table-td-date':
      observe: 'date'
      onGet: (value) -> moment(value).format('ddd MM/DD/YY')

  events:
    'click td:not(:first-child)': ->
      @rootChannel.request 'strength:detail', @model.id
      return

    'click .strength-table-td-remove': ->
      @model.destroy
        wait: true
      return

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')

  onRender: ->
    @stickit()
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
    name:        '#strength-name'
    muscle:      '#strength-muscle'
    first:       '#strength-table-first'
    prev:        '#strength-table-prev'
    next:        '#strength-table-next'
    last:        '#strength-table-last'
    currentPage: '#strength-table-currentpage'
    lastPage:    '#strength-table-lastpage'

  behaviors:
    Pageable:
      behaviorClass: Pageable

  constructor: (options) ->
    super
    @mergeOptions options, 'channel'

  childViewOptions: ->
    return {
      channel: @channel
    }

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Collection = Collection
module.exports.View       = View

#-------------------------------------------------------------------------------
