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

#-------------------------------------------------------------------------------
# Set Model
#-------------------------------------------------------------------------------

class Model extends Backbone.Model

  defaults:
    index:  0
    weight: 0
    rep:    0

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  regions:
    set: '#exercise-strength-set-view'

  ui:
    name:   '#exercise-strength-name'
    type:   '#exercise-strength-type'
    submit: '#exercise-strength-submit'
    addset: '#exercise-strength-addset'
    date:   '#exercise-strength-date'
    time:   '#exercise-strength-time'

  bindings:

    '#exercise-strength-name': 'name'

    '#exercise-strength-note': 'note'

    '#exercise-strength-addset':
      observe: 'count'
      onSet: (value) ->
        if value > @setCollection.length
          @setCollection.add new Model
            index: value
            rep:   0
        else
          @setCollection.remove(@setCollection.last())
        return

  events:
    'click #exercise-strength-exercise': ->
      @rootChannel.request('exercise')
      return

    'click #exercise-strength-time': ->
      @ui.time.timepicker('showWidget')
      return

    'click @ui.submit': ->

      console.log 'MODEL', @model.attributes

      @model.set 'set', @setCollection.toJSON()
      @model.save()

      return

    'submit': (event) ->
      event.preventDefault()
      @model.save {},
        success: =>
          @rootChannel.request('home')
          return
        error: ->
          console.log 'fail'
          return
      return

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')
    @setCollection = new Backbone.Collection(new Model())

  onRender: ->

    @ui.type.multiselect
      enableFiltering: true
      buttonWidth:    '100%'
      buttonClass:    'btn btn-info'
    .multiselect 'dataprovider', [
      { value: 0, label: 'arm'      }
      { value: 1, label: 'leg'      }
      { value: 2, label: 'shoulder' }
      { value: 3, label: 'back'     }
    ]

    @ui.addset.TouchSpin
      buttondown_class: 'btn btn-info'
      buttonup_class:   'btn btn-info'
      min:              1
      max:              100

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
      collection: @setCollection
    return

  onBeforeDestroy: ->
    @ui.date.datepicker('destroy')
    @ui.addset.TouchSpin('destroy')
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
