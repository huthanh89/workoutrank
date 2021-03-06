#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
Marionette   = require 'backbone.marionette'
Data         = require '../../data/module'
viewTemplate = require './view.pug'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.View

  template: viewTemplate

  ui:
    muscle: '#strength-filter-muscle'

  constructor: (options) ->
    super(options)
    @mergeOptions options, [
      'tableCollection'
      'muscle'
    ]

    @muscles = []
    @muscles.push(@muscle) if @muscle?

  onRender: ->

    @ui.muscle.multiselect
      dropRight:    true
      maxHeight:    280
      buttonClass: 'btn btn-default strength-filter-btn'
      buttonWidth:  35
      templates:
        button: '<span class="multiselect dropdown-toggle" data-toggle="dropdown"><i class="fa fa-lg fa-filter"></i></span>'

      # Filter pageable collection on change.

      onChange: =>
        @muscles = _.map @ui.muscle.val(), (value) -> parseInt(value)
        @filterCollection()
    .multiselect 'dataprovider', Data.Muscles
    .multiselect 'select', @muscles

    return

  # Use the clean collection to filter the pageable collection base
  # on muscle types.

  filterCollection: ->

    models = @collection.models

    if @muscles.length > 0
      models = @collection.filter (model) =>
        return _.intersection(@muscles, model.get('muscle')).length > 0

    @tableCollection.reset models

    return

  onBeforeDestroy: ->
    @ui.muscle.multiselect('destroy')
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
