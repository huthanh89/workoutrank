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

  constructor: (options) ->
    super
    @mergeOptions options, 'pageableCollection'
    @muscles = []

  onRender: ->

    @ui.muscle.multiselect
      dropRight:    false
      maxHeight:    350
      buttonClass: 'btn btn-default'
      buttonWidth:  40
      templates:
        button: '<span class="multiselect dropdown-toggle " data-toggle="dropdown"><i class="fa fa-lg fa-filter"></i></i></span>'

      # Filter pageable collection on change.

      onChange: =>
        @muscles = @ui.muscle.val() or []
        @filterCollection()
    .multiselect 'dataprovider', Data.Muscles

    return

  # Use the clean collection to filter the pageable collection base
  # on muscle types.

  filterCollection: ->

    models = @collection.models

    if @muscles.length > 0
      models = @collection.filter (model) =>
        return model.get('muscle').toString() in @muscles

    @pageableCollection.fullCollection.reset models

    return

  onBeforeDestroy: ->
    @ui.muscle.multiselect('destroy')
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
