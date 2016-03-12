#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
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
    set: '#strength-set-view'

  ui:
    name:   '#strength-name'
    type:   '#strength-type'
    submit: '#strength-submit'
    addset: '#strength-addset'
    date:   '#strength-date'
    time:   '#strength-time'
    form:   '#strength-form'

  bindings:

    '#strength-name': 'name'

    '#strength-note': 'note'

    '#strength-addset':
      observe: 'count'
      onSet: (value) ->
        if value > @sessionCollection.length
          @sessionCollection.add new Model
            index: value
        else
          @sessionCollection.remove(@sessionCollection.last())
        return

  events:

    'click #strength-exercise': ->
      @rootChannel.request('exercise')
      return

    'click #strength-time': ->
      @ui.time.timepicker('showWidget')
      return

    'click @ui.submit': ->

      @ui.form.validator('validate')
      @model.set 'session', @sessionCollection.toJSON()
      @ui.form.validator('validate')

      @model.save {},
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
        template: 'dropdown'
    .timepicker('setTime', '12:45 AM')

    @stickit()
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
