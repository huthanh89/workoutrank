#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

$            = require 'jquery'
moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
Data         = require '../../data/module'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'backbone.stickit'
require 'bootstrap.datetimepicker'

#-------------------------------------------------------------------------------
# Model
#-------------------------------------------------------------------------------

class Model extends Backbone.Model

  idAttribute: '_id'

  defaults:
    date:   moment()
    name:   ''
    muscle: 0
    note:   ''
    body:   false
    schedule: [false, false, false, false, false, false, false]

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  ui:
    dialog: '#strength-modal-dialog'
    name:   '#strength-modal-name'
    muscle: '#strength-modal-muscle'
    body:   '#strength-modal-body'
    date:   '#strength-modal-date'
    submit: '#strength-modal-submit'
    btn0:   '#strength-modal-schedule0'
    btn1:   '#strength-modal-schedule1'
    btn2:   '#strength-modal-schedule2'
    btn3:   '#strength-modal-schedule3'
    btn4:   '#strength-modal-schedule4'
    btn5:   '#strength-modal-schedule5'
    btn6:   '#strength-modal-schedule6'
    btn7:   '#strength-modal-schedule7'

  bindings:

    '#strength-modal-name': 'name'

    '#strength-modal-note': 'note'

    '#strength-modal-muscle':
      observe: 'muscle'
      onSet: (value) -> parseInt(value)

  events:

    'shown.bs.modal': ->
      @ui.body.prop 'checked', @model.get('body')
      return

    'click @ui.body': ->
      @model.set 'body', @ui.body.is(':checked')
      return

    'submit': (event) ->
      event.preventDefault()

      @model.set
        date: @ui.date.data('DateTimePicker').date().format()

      @collection.create @model.attributes,
        wait: true
        at:   0
        success:  =>
          @ui.dialog.modal('hide')
          return
        error: (model, response) =>
          @rootChannel.request 'message:error', response
          return

      return

    'hidden.bs.modal': ->
      @ui.muscle.multiselect('destroy')
      @ui.date.data('DateTimePicker').destroy()
      return

    'click @ui.btn0': (event) ->
      @toggleButton($(event.currentTarget), 0)
      return

    'click @ui.btn1': (event) ->
      @toggleButton($(event.currentTarget), 1)
      return

    'click @ui.btn2': (event) ->
      @toggleButton($(event.currentTarget), 2)
      return

    'click @ui.btn3': (event) ->
      @toggleButton($(event.currentTarget), 3)
      return

    'click @ui.btn4': (event) ->
      @toggleButton($(event.currentTarget), 4)
      return

    'click @ui.btn5': (event) ->
      @toggleButton($(event.currentTarget), 5)
      return

    'click @ui.btn6': (event) ->
      @toggleButton($(event.currentTarget), 6)
      return

    'click @ui.btn7': (event) ->
      @toggleButton($(event.currentTarget), 7)
      return

  toggleButton: (buttonUI, btnNumber) ->

    schedule = @model.get('schedule')
    state = schedule[btnNumber]

    color = if state then '#555555' else 'red'
    buttonUI.css 'color', color

    schedule[btnNumber] = not state
    @model.set 'schedule', schedule

    return

  constructor: (options) ->
    super
    @mergeOptions options, 'edit'
    @rootChannel = Backbone.Radio.channel('root')

  onRender: ->

    date = moment(@model.get('date'))

    @ui.muscle.multiselect
      maxHeight:     330
      buttonWidth:  '100%'
      buttonClass:  'btn btn-default'
    .multiselect 'dataprovider', Data.Muscles
    .multiselect('select', @model.get('muscle'))

    @ui.date.datetimepicker
      inline:      true
      sideBySide:  false
      minDate:     moment(date).subtract(1, 'years')
      maxDate:     moment(date).add(1, 'years')
      defaultDate: moment(date)

    @stickit()

    # Show this dialog

    @ui.dialog.modal()

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Model = Model
module.exports.View  = View

#-------------------------------------------------------------------------------
