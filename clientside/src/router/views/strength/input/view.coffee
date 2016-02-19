#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

$            = require 'jquery'
_            = require 'lodash'
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

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:
    name: '#exercise-strength-name'
    type: '#exercise-strength-type'
    set:  '#exercise-strength-set'
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

  onRender: ->

    @ui.set.TouchSpin()
    @ui.rep.TouchSpin()

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

  onDestroy: ->
    @ui.date.datepicker('destroy')
    @ui.set.TouchSpin('destroy')
    @ui.rep.TouchSpin('destroy')
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
