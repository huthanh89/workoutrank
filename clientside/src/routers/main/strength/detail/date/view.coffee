#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
Marionette   = require 'marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'bootstrap.datetimepicker'

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
      @ui.date.data('DateTimePicker').date date
      return

    'click @ui.next': ->
      currentDate = @model.get('date')
      date = moment(currentDate).add(1, 'days')
      @model.set('date', date)
      @ui.date.data('DateTimePicker').date date
      return

  onRender: ->
    @ui.date.datetimepicker
      viewMode:   'days'
      format:     'MMM DD, YYYY'
      minDate:     moment().subtract(100, 'years')
      maxDate:     moment().add(1, 'years')
      defaultDate: moment()
      widgetPositioning:
        vertical: 'bottom'
      ignoreReadonly: true

    @ui.date.on 'dp.change', =>
      @model.set 'date', @ui.date.data('DateTimePicker').date()
      return
    return

  onBeforeDestroy: ->
    @ui.date.data('DateTimePicker').destroy()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
