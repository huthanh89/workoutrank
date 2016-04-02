#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Backbone     = require 'backbone'
Marionette   = require 'marionette'
Data         = require '../../data/module'
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

  idAttribute: '_id'

  defaults:
    date:    new Date()
    name:    ''
    muscle:  0
    note:    ''

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  ui:
    dialog: '.modal'
    name:   '#strength-modal-name'
    muscle: '#strength-modal-muscle'
    addset: '#strength-modal-addset'
    date:   '#strength-modal-date'
    time:   '#strength-modal-time'
    form:   '#strength-modal-form'
    submit: '#strength-modal-submit'

  bindings:

    '#strength-modal-name': 'name'

    '#strength-modal-note': 'note'

    '#strength-modal-muscle':
      observe: 'muscle'
      onSet: (value) -> parseInt(value)

  events:

    'shown.bs.modal': ->
      @ui.name.focus()
      return

    'click @ui.time': ->
      @ui.time.timepicker('showWidget')
      return

    'click @ui.submit': ->

      @ui.form.validator('validate')

      @collection.create @model.attributes,
        wait: true
        at:   0
        success: =>
          @ui.dialog.modal('hide')
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
    .multiselect('select', @model.get('muscle'))

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

    # Show this dialog

    @ui.dialog.modal()

    return

  onBeforeDestroy: ->
    @ui.muscle.multiselect('destroy')
    @ui.form.validator('destroy')
    @ui.date.datepicker('destroy')
    @ui.addset.TouchSpin('destroy')
    return


#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Model = Model
module.exports.View  = View

#-------------------------------------------------------------------------------
