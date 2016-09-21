#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
Marionette   = require 'marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:
    date: '#strength-date-datepicker'
    prev: '#strength-date-prev'
    next: '#strength-date-next'

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
    @ui.date.val moment(@date).format('dddd MMM DD')
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
