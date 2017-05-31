#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
Marionette   = require 'backbone.marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'bootstrap.datetimepicker'

#-------------------------------------------------------------------------------
# Model
#-------------------------------------------------------------------------------

class Model extends Backbone.Model
  defaults:
    date: new Date()

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.View

  template: viewTemplate

  ui:
    date: '#weight-date-datepicker'
    prev: '#weight-date-prev'
    next: '#weight-date-next'

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
      format:     'YYYY-MM-DD'
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

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

exports.Model = Model
exports.View  = View

#-------------------------------------------------------------------------------
