#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
Backbone     = require 'backbone'
Validation   = require 'backbone.validation'
Marionette   = require 'marionette'
Data         = require '../data/module'
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

class View extends Marionette.LayoutView

  template: viewTemplate

  ui:
    back:   '#strength-exercise'
    name:   '#strength-name'
    muscle: '#strength-muscle'
    submit: '#strength-submit'
    addset: '#strength-addset'
    date:   '#strength-date'
    time:   '#strength-time'
    form:   '#strength-form'

  bindings:

    '#strength-name': 'name'
    '#strength-note': 'note'

    '#strength-muscle':
      observe: 'muscle'
      onSet: (value) -> parseInt(value)

  events:

    'click @ui.back': ->
      @rootChannel.request('exercise')
      return

    'click @ui.time': ->
      @ui.time.timepicker('showWidget')
      return

    'click @ui.submit': ->

      @ui.form.validator('validate')

      @collection.fullCollection.create @model.attributes,
        wait: true
        at:   0
        success: =>
          @ui.name.val('')
          return

      return

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')

  onRender: ->

    @ui.muscle.multiselect
      enableFiltering: true
      maxHeight:       200
      buttonWidth:    '100%'
      buttonClass:    'btn btn-info'
    .multiselect 'dataprovider', Data.Muscles
    @ui.addset.TouchSpin
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
    .timepicker('setTime', '12:45 AM')

    @stickit()
    return

  onShow: ->
    @ui.name.focus()
    return

  onBeforeDestroy: ->
    @ui.form.validator('destroy')
    @ui.date.datepicker('destroy')
    @ui.addset.TouchSpin('destroy')
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
