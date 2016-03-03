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
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  regions:
    set: '#exercise-strength-set-view'

  ui:
    name: '#exercise-strength-name'
    type: '#exercise-strength-type'
    rep:  '#exercise-strength-rep'
    date: '#exercise-strength-date'
    time: '#exercise-strength-time'

  bindings:
    '#exercise-strength-name': 'name'
    '#exercise-strength-note': 'note'

  events:
    'click #exercise-strength-time': ->
      @ui.time.timepicker('showWidget')
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
    @setCollection = new Backbone.Collection([
      {a:1, b:2}
      {a:1, b:2}
    ])

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
    @ui.rep.TouchSpin
      buttondown_class: 'btn btn-primary'
      buttonup_class:   'btn btn-primary'

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

  onDestroy: ->
    @ui.date.datepicker('destroy')
    @ui.rep.TouchSpin('destroy')
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
