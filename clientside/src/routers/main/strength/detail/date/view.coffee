#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
Marionette   = require 'marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'datepicker'

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
      currentDate = @model.get('date')
      date = moment(currentDate).subtract(1, 'days')
      @model.set('date', date)
      @ui.date.datepicker('setDate', new Date(date.format()))
      return

    'click @ui.next': ->
      currentDate = @model.get('date')
      date = moment(currentDate).add(1, 'days')
      @model.set('date', date)
      @ui.date.datepicker('setDate', new Date(date.format()))
      return

  onRender: ->

    @ui.date.datepicker
      todayBtn:      'linked'
      todayHighlight: true
      format: 'D mm/dd/yyyy'
    .on 'changeDate', =>
      @model.set('date', moment(new Date(@ui.date.val())))
      return
    .datepicker('setDate', new Date())

    return

  onBeforeDestroy: ->
    @ui.date.datepicker('destroy')
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
