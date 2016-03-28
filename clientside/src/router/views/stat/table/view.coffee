#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

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
# Null View
#-------------------------------------------------------------------------------

class NullView extends Marionette.CompositeView
  tagName: 'tr'
  template: nullTemplate

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class ItemView extends Marionette.CompositeView

  tagName: 'tr'

  template: itemTemplate

  bindings:

    '.stat-table-td-name': 'name'

    '.stat-table-td-max': 'max'

    '.stat-table-td-date':
      observe: 'date'
      onGet: (value) -> moment(value).format('MM/DD/YY')

    '.stat-table-td-avg': 'avg'

  onRender: ->
    @stickit()
    return

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.CompositeView

  childViewContainer: 'tbody'

  childView: ItemView

  emptyView: NullView

  template: viewTemplate

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
