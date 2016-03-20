#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Marionette   = require 'marionette'
Data         = require '../../data/module'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:
    muscle: '#strength-filter-muscle'

  bindings:
    '#strength-filter-muscle':
      observe: 'muscle'
      onSet: (value) -> parseInt(value)

  modelEvents:
    'change:muscle': (model, value) ->
      @ui.muscle.multiselect('select', value)
      return

  onRender: ->

    @ui.muscle.multiselect
      enableFiltering: true
      maxHeight:       200
      buttonWidth:    '100%'
      buttonClass:    'btn btn-info'
    .multiselect 'dataprovider', Data.Muscles

    @stickit()

    return

  onBeforeDestroy: ->
    @ui.muscle.multiselect('destroy')
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
