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

require 'datepicker'
require 'timepicker'
require 'backbone.stickit'

#-------------------------------------------------------------------------------
# Model
#-------------------------------------------------------------------------------

class Model extends Backbone.Model

  idAttribute: '_id'

  defaults:
    date:   new Date()
    name:   ''
    muscle: 0
    note:   ''
    body:   false

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
    addset: '#strength-modal-addset'
    date:   '#strength-modal-date'
    time:   '#strength-modal-time'
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
      @ui.body.prop 'checked', @model.get('body')
      return

    'click @ui.time': ->
      @ui.time.timepicker('showWidget')
      return

    'click @ui.body': ->
      @model.set 'body', @ui.body.is(':checked')
      return

    'click #strength-modal-delete': (event) ->
      event.preventDefault()
      @model.destroy
        wait: true
        success: =>
          @redirect = true
          @ui.dialog.modal('hide')
          return
      return

    'submit': (event) ->
      event.preventDefault()
      @model.save {},
        success: =>
          @ui.dialog.modal('hide')
          return
      return

    'hidden.bs.modal': ->
      @ui.muscle.multiselect('destroy')
      @ui.date.datepicker('destroy')
      @ui.addset.TouchSpin('destroy')
      Backbone.Radio.channel('root').request('strengths') if @redirect
      return

  constructor: (options) ->
    super
    @mergeOptions options, 'edit'
    @rootChannel = Backbone.Radio.channel('root')
    @redirect    = false

  onRender: ->

    @ui.muscle.multiselect
      maxHeight:     330
      buttonWidth:  '100%'
      buttonClass:  'btn btn-info'
    .multiselect 'dataprovider', Data.Muscles
    .multiselect('select', @model.get('muscle'))

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

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Model = Model
module.exports.View  = View

#-------------------------------------------------------------------------------
