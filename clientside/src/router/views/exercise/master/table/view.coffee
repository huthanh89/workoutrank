#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

$            = require 'jquery'
_            = require 'lodash'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
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
    '.exercise-table-td-type': 'type'

  events:
    click: ->
      console.log 'click'
      @rootChannel.request 'exercise:detail', @model.get('type')
      return

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')

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

  ui:
    name: '#exercise-name'
    type: '#exercise-type'

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
