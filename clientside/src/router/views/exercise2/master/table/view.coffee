#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
Data         = require '../data/module'
itemTemplate = require './item.jade'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'backbone.stickit'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class ItemView extends Marionette.CompositeView

  tagName: 'tr'

  template: itemTemplate

  bindings:

    '.exercise-table-td-name': 'name'

    '.exercise-table-td-date':
      observe: 'date'
      onGet: (value) -> moment(value).format('dddd MM/DD/YY hh:mm:ss')

    '.exercise-table-td-type': 'type'

  events:

    click: ->
      type = @model.get('type')
      label = _.find(Data.Types, value: type).label
      @rootChannel.request 'exercise:detail', label.toLowerCase(), @model.get('name')
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

  childView: ItemView

  template: viewTemplate

  ui:
    first:       '#exercise-table-first'
    prev:        '#exercise-table-prev'
    next:        '#exercise-table-next'
    last:        '#exercise-table-last'
    currentPage: '#exercise-table-currentpage'
    lastPage:    '#exercise-table-lastpage'

  collectionEvents:

    'reset': ->
      @setPage()
      return

    'sync update': ->
      @collection.getFirstPage()
      @setPage()
      return

  events:

    'click @ui.first': ->
      @collection.getFirstPage()
      return

    'click @ui.prev': ->
      if @collection.hasPreviousPage()
        @collection.getPreviousPage()
      return

    'click @ui.next': ->
      if @collection.hasNextPage()
        @collection.getNextPage()
      return

    'click @ui.last': ->
      @collection.getLastPage()
      return

  onRender: ->
    @collection.getFirstPage()
    @setPage()
    return

  setPage: ->
    state = @collection.state
    $(@ui.currentPage).text state.currentPage
    $(@ui.lastPage).text state.lastPage
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
