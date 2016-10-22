#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'backbone.stickit'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  serializeData: -> {}

  className: 'infinite-item'

  ui:
    growth: '.timeline-weight-growth'

  bindings:

    '.timeline-weight-date':
      observe: 'date'
      onGet: (value) -> moment(value).fromNow()

    '.timeline-weight-value': 'weight'

    '.timeline-weight-change':
      observe: 'change'
      updateMethod: 'html'
      onGet: (value) ->
        if value > 0
          return "<span style='color:red;'>+#{value}</span>"
        else if value < 0
          return "<span style='color:green;'>#{value}</span>"
        else
          return "<span style='color:green;'>+#{value}</span>"

    '.timeline-weight-growth':
      observe: 'growth'
      updateMethod: 'html'
      onGet: (value) ->
        if value is 'down'
          return "<i class='fa fa-fw fa-lg fa-long-arrow-down' style='color:#3b9f38'></i>"
        else if value is 'up'
          return "<i class='fa fa-fw fa-lg fa-long-arrow-up' style='color:rgba(232, 33, 30, 0.84);'></i>"
        else
          return "<i class='fa fa-fw fa-lg fa-minus' style='color:#3b9f38'></i>"

    '.timeline-weight-avg':
      observe: 'avg'
      updateMethod: 'html'
      onGet: (value) ->

        span = "<span>#{value}</span>"

        if value is 'down'
          return "<i class='fa fa-fw fa-lg fa-long-arrow-down' style='color:#3b9f38'></i><span>Below Average</span>"
        else if value is 'up'
          return "<i class='fa fa-fw fa-lg fa-long-arrow-up' style='color:rgba(232, 33, 30, 0.84);'></i><span>Above Average</span>"
        else
          return "<i class='fa fa-fw fa-lg fa-minus'></i><span>Average</span>"

    '.timeline-weight-percent':
      observe:      'percent'
      updateMethod: 'html'
      onGet: (value) ->
        if value > 0
          return "<span style='color:red;'>(+#{value}%)</span>"
        else if value < 0
          return "<span style='color:green;'>(#{value}%)</span>"
        else
          return "<span style='color:green;'>(+#{value}%)</span>"

    '.timeline-weight-note-container':
      observe: 'note'
      visible: (value) -> value

    '.timeline-weight-note': 'note'

  onRender: ->
    @stickit @model
    return

  onBeforeDestroy: ->
    @unstickit()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.View = View

#-------------------------------------------------------------------------------
