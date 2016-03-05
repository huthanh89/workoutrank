#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
Data         = require '../data/module'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'multiselect'
require 'backbone.stickit'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:
    name: '#exercise-name'
    type: '#exercise-type'

  bindings:
    '#exercise-name': 'name'

    '#exercise-type':
      observe: 'type'
      onSet: (value) -> parseInt(value)

  events:
    'submit': (event) ->
      event.preventDefault()
      @collection.create @model.attributes,
        wait: true
      return

  constructor: (options) ->
    super
    @mergeOptions options, 'channel'
    @rootChannel = Backbone.Radio.channel('root')

  onRender: ->

    @ui.type.multiselect
      enableFiltering: true
      buttonWidth:    '100%'
      buttonClass:    'btn btn-info'
    .multiselect 'dataprovider', Data.Types
    .multiselect 'deselect',     0
    .multiselect 'select',       @model.get('type')

    @stickit()
    return

  onShow: ->
    @ui.name.focus()
    return

  onBeforeDestroy: ->
    @ui.type.multiselect('destroy')
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
