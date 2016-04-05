#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Marionette   = require 'marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'bootstrap.paginate'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:
    list: '#strength-paginate-list'

  collectionEvents:
    reset: ->
      @updateList()
      return

  events:

    'click li': (event) ->

      # Do nothing if disabled li was clicked

      target = $(event.currentTarget)

      return if target.hasClass('disabled')

      id = target.attr('id')

      if id is 'prev'
        if @collection.hasPreviousPage()
          @collection.getPreviousPage()

      else if id is 'next'
        if @collection.hasNextPage()
          @collection.getNextPage()

      else
        page = parseInt(target.attr('id'))
        @collection.getPage(page)

      @updateList()
      return

  onShow: ->
    @updateList()
    return

  updateList: ->

    @ui.list.empty()

    # Paginate

    state       = @collection.state
    currentPage = state.currentPage
    firstPage   = state.firstPage
    lastPage    = state.lastPage

    @ui.list.append '<li id="prev" class="pagination-prev"><a>Prev</a></li>'

    for page in [firstPage..lastPage]
      if page is currentPage
        @ui.list.append  '<li class="active" id=' + page + "><a>#{page}</a></li>"
      else
        @ui.list.append  '<li id=' + page + "><a>#{page}</a></li>"

    @ui.list.append '<li  id="next" class="pagination-next"><a>Next</a></li>'

    @ui.list.rPage()

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
