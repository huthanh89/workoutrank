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
    type: '#exercise-type'
    go:   '#exercise-go'

  bindings:
    '#exercise-type':
      observe: 'type'
      onSet: (value) -> parseInt(value)

  events:
    'click @ui.go': (event) ->
      event.preventDefault()
      label = _.find(Data.Types, value: @model.get('type')).label
      @rootChannel.request 'exercise:detail', label.toLowerCase()
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

  onBeforeDestroy: ->
    @ui.type.multiselect('destroy')
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
