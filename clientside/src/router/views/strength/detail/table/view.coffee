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

    '.strength-table-td-time':
      observe: 'date'
      onGet: (value) -> moment(value).format('h:mm A')

    '.strength-table-td-rep': 'rep'

    '.strength-table-td-weight': 'weight'

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
