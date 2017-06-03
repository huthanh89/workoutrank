#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
Marionette   = require 'backbone.marionette'
viewTemplate = require './view.pug'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.View

  template: viewTemplate

  ui:
    date: '#cardio-date-datepicker'
    prev: '#cardio-date-prev'
    next: '#cardio-date-next'

  events:

    'click @ui.prev': ->
      @channel.request 'change:date', moment(@date).subtract(1, 'days')
      return

    'click @ui.next': ->
      @channel.request 'change:date', moment(@date).add(1, 'days')
      return

    'click @ui.date': ->
      @channel.request 'add:workout', @date
      return

  constructor: (options) ->
    super
    @mergeOptions options, [
      'date'
      'channel'
    ]

  onRender: ->
    @ui.date.html moment(@date).format('dddd MMM DD')
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
