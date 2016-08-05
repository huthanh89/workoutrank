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
# Model
#-------------------------------------------------------------------------------

class Model extends Backbone.Model

  url: '/api/slogs'

  idAttribute: '_id'

  defaults:
    date:     new Date()
    name:     ''
    exercise: ''
    rep:      1
    weight:   1
    muscle:   0
    note:     ''

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

    'shown.bs.modal': ->
      @ui.weight.focus()
      return

    'click #strength-modal-exercise': ->
      @rootChannel.request('exercise')
      return

    'click #strength-modal-date-btn': ->
      @ui.date.datepicker 'show'
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
        success: (model) =>
          @collection.add model.attributes
          @ui.dialog.modal('hide')
          return
        error: ->
          console.log 'fail'
          return

      return

    'hidden.bs.modal': ->
      @ui.form.validator('destroy')
      @ui.date.datepicker('destroy')
      @ui.rep.TouchSpin('destroy')
      @ui.weight.TouchSpin('destroy')
      @unstickit()
      return

  constructor: (options) ->
    super
    @rootChannel = Backbone.Radio.channel('root')
    @model.set('date', new Date(options.date))

  onRender: ->

    date = @model.get('date')

    @ui.rep.TouchSpin
      buttondown_class: 'btn btn-info'
      buttonup_class:   'btn btn-info'
      min:              1
      max:              99999

    @ui.weight.TouchSpin
      buttondown_class: 'btn btn-info'
      buttonup_class:   'btn btn-info'
      min:              1
      max:              9999

    @ui.date.datepicker
      todayBtn:      'linked'
      todayHighlight: true
    .on 'changeDate', =>
      @model.set('date', new Date(@ui.date.val()))
      return
    .datepicker('setDate', date)

    @ui.time
    .timepicker
      template: 'dropdown'
    .timepicker('setTime', moment(date).format('HH:mm:ss'))

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
