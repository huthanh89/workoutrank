#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
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

    '.timeline-cardio-name': 'name'

    '.timeline-cardio-date':
      observe: 'date'
      onGet: (value) -> moment(value).fromNow()

    '.timeline-cardio-duration':    'duration'

    '.timeline-cardio-changeDuration':
      observe: 'durationChange'
      updateMethod: 'html'
      onGet: (value) ->
        if value > 0
          return "<span style='color:green;'>+#{value}</span>"
        else if value < 0
          return "<span style='color:red;'>#{value}</span>"
        else
          return "<span style='color:green;'>+#{value}</span>"

    '.timeline-cardio-growthDuration':
      observe: 'durationGrowth'
      updateMethod: 'html'
      onGet: (value) ->
        if value is 'down'
          return "<i class='fa fa-fw fa-lg fa-long-arrow-down' style='color:red'></i>"
        else if value is 'up'
          return "<i class='fa fa-fw fa-lg fa-long-arrow-up' style='color:green;'></i>"
        else
          return "<i class='fa fa-fw fa-lg fa-minus' style='color:green'></i>"

    '.timeline-cardio-percentDuration':
      observe:      'durationPercent'
      updateMethod: 'html'
      onGet: (value) ->
        if value > 0
          return "<span style='color:green;'>(+#{value}%)</span>"
        else if value < 0
          return "<span style='color:red;'>(#{value}%)</span>"
        else
          return "<span style='color:green;'>(+#{value}%)</span>"

    '.timeline-cardio-intensity': 'intensity'

    '.timeline-cardio-changeIntensity':
      observe: 'intensityChange'
      updateMethod: 'html'
      onGet: (value) ->
        if value > 0
          return "<span style='color:green;'>+#{value}</span>"
        else if value < 0
          return "<span style='color:red;'>#{value}</span>"
        else
          return "<span style='color:green;'>+#{value}</span>"

    '.timeline-cardio-growthIntensity':
      observe: 'intensityGrowth'
      updateMethod: 'html'
      onGet: (value) ->
        if value is 'down'
          return "<i class='fa fa-fw fa-lg fa-long-arrow-down' style='color:red'></i>"
        else if value is 'up'
          return "<i class='fa fa-fw fa-lg fa-long-arrow-up' style='color:green;'></i>"
        else
          return "<i class='fa fa-fw fa-lg fa-minus' style='color:green'></i>"

    '.timeline-cardio-percentIntensity':
      observe:      'intensityPercent'
      updateMethod: 'html'
      onGet: (value) ->
        if value > 0
          return "<span style='color:green;'>(+#{value}%)</span>"
        else if value < 0
          return "<span style='color:red;'>(#{value}%)</span>"
        else
          return "<span style='color:green;'>(+#{value}%)</span>"

    '.timeline-cardio-note-container':
      observe: 'note'
      visible: (value) -> value

    '.timeline-cardio-note': 'note'

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
