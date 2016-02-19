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

  bindings:
    '#exercise-strength-name': 'name'
    '#exercise-strength-note': 'note'

  events:
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
    @stickit()
    return

  onDestroy: ->
    @ui.set.TouchSpin('destroy')
    @ui.rep.TouchSpin('destroy')
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
