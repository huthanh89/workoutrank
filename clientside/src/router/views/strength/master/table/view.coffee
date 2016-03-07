#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
Pageable     = require 'src/behavior/pageable/module'
Data         = require '../data/module'
itemTemplate = require './item.jade'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'multiselect'
require 'backbone.stickit'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class ItemView extends Marionette.ItemView

  tagName: 'tr'

  template: itemTemplate

  bindings:

    '.exercise-table-td-name': 'name'

    '.exercise-table-td-date':
      observe: 'date'
      onGet: (value) -> moment(value).format('dddd MM/DD/YY hh:mm')

    '.exercise-table-td-muscle': 'muscle'

  events:

    click: ->
      @rootChannel.request 'strength:detail', @model.id
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

  behaviors:
    Pageable:
      behaviorClass: Pageable

  ui:
    name:        '#exercise-name'
    muscle:      '#exercise-muscle'
    first:       '#exercise-table-first'
    prev:        '#exercise-table-prev'
    next:        '#exercise-table-next'
    last:        '#exercise-table-last'
    currentPage: '#exercise-table-currentpage'
    lastPage:    '#exercise-table-lastpage'

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
