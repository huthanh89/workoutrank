#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

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

      return

    'hidden.bs.modal': ->
      @ui.muscle.multiselect('destroy')
      @ui.addset.TouchSpin('destroy')
      @ui.date.data('DateTimePicker').destroy()
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
