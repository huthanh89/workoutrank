#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
Pageable     = require 'src/behavior/pageable/module'
Data         = require '../../data/module'
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

    '.strength-table-td-name': 'name'

    '.strength-table-td-date':
      observe: 'date'
      onGet: (value) -> moment(value).format('ddd MM/DD/YY')

    '.strength-table-td-muscle':
      observe: 'muscle'
      onGet: (value) -> _.find(Data.Muscles, value: value).label

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

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
