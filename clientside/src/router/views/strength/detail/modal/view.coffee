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

require 'touchspin'
require 'datepicker'
require 'timepicker'
require 'backbone.stickit'
require 'bootstrap.validator'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:
    dialog: '.modal'
    type:   '#strength-modal-type'
    rep:    '#strength-modal-rep'
    weight: '#strength-modal-weight'
    submit: '#strength-modal-submit'
    date:   '#strength-modal-date'
    time:   '#strength-modal-time'
    form:   '#strength-modal-form'

  bindings:

    '#strength-modal-rep':
      observe: 'rep'
      onSet: (value) -> parseInt(value)

    '#strength-modal-weight':
      observe: 'weight'
      onSet: (value) -> parseInt(value)

    '#strength-modal-note': 'note'

  events:

    'click #strength-modal-exercise': ->
      @rootChannel.request('exercise')
      return

    'click #strength-modal-time': ->
      @ui.time.timepicker('showWidget')
      return

    'click @ui.submit': ->

      date = moment(new Date(@ui.date.val())).format('YYYY-MM-DD')
      time = @ui.time.val()

      @model.set
        date: moment(new Date("#{date} #{time}")).format()

      @model.save {},
        success: =>
          @ui.dialog.modal('hide')
          return
        error: ->
          console.log 'fail'
          return

      return

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')

  onRender: ->

    @ui.rep.TouchSpin
      buttondown_class: 'btn btn-info'
      buttonup_class:   'btn btn-info'
      min:              1
      max:              20

    @ui.weight.TouchSpin
      buttondown_class: 'btn btn-info'
      buttonup_class:   'btn btn-info'
      min:              1
      max:              20

    @ui.date.datepicker
      todayBtn:      'linked'
      todayHighlight: true
    .on 'changeDate', =>
      @model.set('date', new Date(@ui.date.val()))
      return
    .datepicker('setDate', new Date())

    @ui.time
    .timepicker
      template: 'dropdown'
    .timepicker('setTime', moment().format('HH:mm:ss'))

    @stickit()

    # Show this dialog

    @ui.dialog.modal()

    return

  onBeforeDestroy: ->
    @ui.form.validator('destroy')
    @ui.date.datepicker('destroy')
    @ui.rep.TouchSpin('destroy')
    @ui.weight.TouchSpin('destroy')
    @unstickit()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
