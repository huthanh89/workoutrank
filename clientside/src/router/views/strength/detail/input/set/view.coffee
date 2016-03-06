#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Item View
#-------------------------------------------------------------------------------

class ItemView extends Marionette.ItemView

  template: viewTemplate

  ui:
    rep:    '.exercise-strength-rep'
    weight: '.exercise-strength-weight'

  bindings:

    '.exercise-strength-rep': 'rep'

    '.exercise-strength-weight': 'weight'

    '.exercise-strength-set-label':
      observe: 'index'
      onGet: (value) -> "Set ##{value}"

  onRender: ->

    @ui.rep.TouchSpin()
    @ui.weight.TouchSpin()

    @stickit()
    return

  onBeforeDestroy: ->
    @ui.rep.TouchSpin    'destroy'
    @ui.weight.TouchSpin 'destroy'
    return

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.CollectionView

  template: false

  childView: ItemView

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
