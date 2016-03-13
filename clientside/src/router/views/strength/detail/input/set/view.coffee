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
    rep:    '.strength-rep'
    weight: '.strength-weight'

  bindings:

    '.strength-rep':
      observe: 'rep'
      onSet: (value) -> parseInt(value)

    '.strength-weight':
      observe: 'weight'
      onSet: (value) -> parseInt(value)

    '.strength-set-label':
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
