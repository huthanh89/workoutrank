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

  bindings:

    '.timeline-strength-name': 'name'

    '.timeline-strength-date':
      observe: 'date'
      onGet: (value) -> moment(value).fromNow()

    '.timeline-strength-rep':    'rep'

    '.timeline-strength-changeRep':
      observe: 'repChange'
      updateMethod: 'html'
      onGet: (value) ->
        if value > 0
          return "<span style='color:green;'>+#{value}</span>"
        else if value < 0
          return "<span style='color:red;'>#{value}</span>"
        else
          return "<span style='color:green;'>+#{value}</span>"

    '.timeline-strength-growthRep':
      observe: 'repGrowth'
      updateMethod: 'html'
      onGet: (value) ->
        if value is 'down'
          return "<i class='fa fa-fw fa-lg fa-long-arrow-down' style='color:red'></i>"
        else if value is 'up'
          return "<i class='fa fa-fw fa-lg fa-long-arrow-up' style='color:green;'></i>"
        else
          return "<i class='fa fa-fw fa-lg fa-minus' style='color:green'></i>"

    '.timeline-strength-weight': 'weight'

    '.timeline-strength-changeWeight':
      observe: 'weightChange'
      updateMethod: 'html'
      onGet: (value) ->
        if value > 0
          return "<span style='color:green;'>+#{value}</span>"
        else if value < 0
          return "<span style='color:red;'>#{value}</span>"
        else
          return "<span style='color:green;'>+#{value}</span>"

    '.timeline-strength-growthWeight':
      observe: 'weightGrowth'
      updateMethod: 'html'
      onGet: (value) ->
        if value is 'down'
          return "<i class='fa fa-fw fa-lg fa-long-arrow-down' style='color:red'></i>"
        else if value is 'up'
          return "<i class='fa fa-fw fa-lg fa-long-arrow-up' style='color:green;'></i>"
        else
          return "<i class='fa fa-fw fa-lg fa-minus' style='color:green'></i>"

    '.timeline-strength-note': 'note'

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
