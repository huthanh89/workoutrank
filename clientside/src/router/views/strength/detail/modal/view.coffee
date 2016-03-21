#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
SetView      = require './set/view'
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
#   contain data for each set in a session
#-------------------------------------------------------------------------------

class Model extends Backbone.Model

  idAttribute: '_id'

  defaults:
    index:  1
    weight: 0
    rep:    1

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  regions:
    set: '#strength-modal-set-view'

  ui:
    dialog: '.modal'
    name:   '#strength-modal-name'
    type:   '#strength-modal-type'
    submit: '#strength-modal-submit'
    addset: '#strength-modal-addset'
    date:   '#strength-modal-date'
    time:   '#strength-modal-time'
    form:   '#strength-modal-form'

  bindings:

    '#strength-modal-name': 'name'

    '#strength-modal-note': 'note'

    '#strength-modal-addset':
      observe: 'count'
      onSet: (value) ->
        if value > @sessionCollection.length
          @sessionCollection.add new Model
            index: parseInt(value)
        else
          @sessionCollection.remove(@sessionCollection.last())
        return

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

      @ui.form.validator('validate')
      @model.set 'session', @sessionCollection.toJSON()
      @ui.form.validator('validate')

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

    model = new Model {},
      id: @model.id

    @sessionCollection = new Backbone.Collection(model)

  onRender: ->

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
      template:   'dropdown'
    .timepicker('setTime', moment().format('HH:mm:ss'))

    @stickit()

    # Show this dialog

    @ui.dialog.modal()

    return

  onShow: ->
    @showChildView 'set', new SetView
      collection: @sessionCollection
    return

  onBeforeDestroy: ->
    @ui.form.validator('destroy')
    @ui.date.datepicker('destroy')
    @ui.addset.TouchSpin('destroy')
    @unstickit()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
