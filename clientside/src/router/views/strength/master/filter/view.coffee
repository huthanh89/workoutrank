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
      enableFiltering: true
      maxHeight:       300
      buttonClass:    'btn btn-info'
      onChange: =>
        @muscles = @ui.muscle.val() or []

        console.log @muscles

        @filterCollection()
    .multiselect 'dataprovider', Data.Muscles

    return

  # Use the clean collection to filter the pageable collection base
  # on muscle types.

  filterCollection: ->

    console.log 'called'

    models = @collection.models

    console.log models

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
