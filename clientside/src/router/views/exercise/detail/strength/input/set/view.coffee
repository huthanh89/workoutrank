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
    set:    '.exercise-strength-set'
    weight: '.exercise-strength-weight'

  bindings:

    '.exercise-strength-set': 'set'

    '.exercise-strength-weight': 'weight'

    '.exercise-strength-set-label':
      observe: 'index'
      onGet: (value) -> "Set ##{value}"

  onRender: ->

    @ui.set.TouchSpin()
    @ui.weight.TouchSpin()

    @stickit()
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
