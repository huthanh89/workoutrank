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
require 'backbone.stickit'
require 'bootstrap.datetimepicker'

#-------------------------------------------------------------------------------
# Given an array of models, return the latest date.
#-------------------------------------------------------------------------------

lastWeight = (collection) ->
  model = _.maxBy collection.models, (model) -> model.get('date')
  return model.get('weight')

#-------------------------------------------------------------------------------
# Model
#-------------------------------------------------------------------------------

class Model extends Backbone.Model

  url: '/api/slogs'

  idAttribute: '_id'

  defaults:
    date:     moment()
    name:     ''
    exercise: ''
    rep:      null
    weight:   null
    note:     ''
    body:     false

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:
    dialog:     '.modal'
    rep:        '#strength-modal-rep'
    weight:     '#strength-modal-weight'
    submit:     '#strength-modal-submit'
    date:       '#strength-modal-date'
    time:       '#strength-modal-time'
    weightView: '#strength-modal-weight-container'
    labelView:  '#strength-modal-weight-label-container'

  bindings:

    '#strength-modal-timestamp-date':
      observe: 'date'
      onGet: (value) -> moment(value).format('MMMM DD, YYYY')

    '#strength-modal-timestamp-time':
      observe: 'date'
      onGet: (value) -> moment(value).format('hh:mm a')

    '#strength-modal-rep':
      observe: 'rep'
      onSet: (value) -> parseInt(value)

    '#strength-modal-weight':
      observe: 'weight'
      onSet: (value) -> parseInt(value)

    '#strength-modal-weight-label':
      observe: 'weight'
      onGet: (value) -> value + ' lbs'

    '#strength-modal-note': 'note'

  events:

    'click #strength-modal-exercise': ->
      @rootChannel.request('exercise')
      return

    'submit': (event) ->

      event.preventDefault()

      @rootChannel.request 'spin:page:loader', true

      @model.save {},
        success: (model) =>
          @rootChannel.request 'spin:page:loader', false
          @collection.add model.attributes
          @ui.dialog.modal('hide')
          return
        error: (model, response) =>
          @rootChannel.request 'message:error', response
          return

      return

    'hidden.bs.modal': ->
      @ui.rep.TouchSpin('destroy')
      @ui.weight.TouchSpin('destroy')
      @ui.date.data('DateTimePicker').destroy()
      @unstickit()
      return

  constructor: (options) ->
    super
    @rootChannel = Backbone.Radio.channel('root')

    @mergeOptions options, 'wLogs'

    if options.date
      @model.set('date', options.date)

    # If there are data, use the latest data found in collection
    # as default values.

    if @collection.length
      latestModel = @collection.at(@collection.length - 1)
      @model.set 'rep', latestModel.get('rep')
      @model.set 'weight', latestModel.get('weight')

    user = Backbone.Radio.channel('user').request 'user'

    # Set to latest wLogs entry.

    if @model.get('body') and @wLogs.length
      @model.set 'weight', lastWeight @wLogs

  onRender: ->

    date = @model.get('date')

    @ui.rep.TouchSpin
      buttondown_class: 'btn btn-info'
      buttonup_class:   'btn btn-info'
      min:              0
      max:              99999

    if @model.get('body')
      @ui.weightView.hide()
    else
      @ui.labelView.hide()
      @ui.weight.TouchSpin
        postfix:          'pounds'
        buttondown_class: 'btn btn-info'
        buttonup_class:   'btn btn-info'
        min:              0
        max:              99999

    @ui.date.datetimepicker
      inline:      true
      sideBySide:  false
      minDate:     moment(date).subtract(1, 'years')
      maxDate:     moment(date).add(1, 'years')
      defaultDate: moment(date)

    @ui.date.on 'dp.change', =>
      @model.set 'date', @ui.date.data('DateTimePicker').date()
      return

    @stickit()

    # Show this dialog

    @ui.dialog.modal()

    return

  onBeforeDestroy: ->
    $('.modal-backdrop').remove()
    $('body').removeClass 'modal-open'
    @unstickit()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Model = Model
module.exports.View  = View

#-------------------------------------------------------------------------------
