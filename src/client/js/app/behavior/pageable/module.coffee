#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Marionette = require 'backbone.marionette'

#-------------------------------------------------------------------------------
# Behavior
#   Controls table pagination
#   Requires the following in the view;
#     ui:
#       prev, next, last, currentPage, lastPage
#     collection: PageableCollection
#-------------------------------------------------------------------------------

class Behavior extends Marionette.Behavior

  collectionEvents:

    'reset': ->
      @setPage()
      return

    'sync update': ->
      @view.collection.getFirstPage()
      @setPage()
      return

  events:

    'click @ui.first': ->
      @view.collection.getFirstPage()
      return

    'click @ui.prev': ->
      if @view.collection.hasPreviousPage()
        @view.collection.getPreviousPage()
      return

    'click @ui.next': ->

      if @view.collection.hasNextPage()
        @view.collection.getNextPage()
      return

    'click @ui.last': ->
      @view.collection.getLastPage()
      return

  onRender: ->

    @view.collection.getFirstPage()
    @setPage()
    return

  setPage: ->
    state = @view.collection.state

    $(@view.ui.currentPage).text state.currentPage
    $(@view.ui.lastPage).text state.lastPage

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = Behavior

#-------------------------------------------------------------------------------
