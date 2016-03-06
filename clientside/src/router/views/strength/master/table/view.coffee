#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

$            = require 'jquery'
_            = require 'lodash'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
Pageable     = require 'src/behavior/pageable/module'
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

class ItemView extends Marionette.CompositeView

  tagName: 'tr'

  template: itemTemplate

  bindings:
    '.exercise-table-td-name': 'name'

  onRender: ->
    @stickit()
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
    type:        '#exercise-type'
    first:       '#exercise-table-first'
    prev:        '#exercise-table-prev'
    next:        '#exercise-table-next'
    last:        '#exercise-table-last'
    currentPage: '#exercise-table-currentpage'
    lastPage:    '#exercise-table-lastpage'

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')
    console.log 'table'

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
