#--------------------------------------------------------------------------------
# Imports
#--------------------------------------------------------------------------------

_            = require 'lodash'
$            = require 'jquery'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
ItemView     = require './item/view'
viewTemplate = require './view.jade'

PageableCollection = require 'backbone.paginator'

require 'stickit'

#--------------------------------------------------------------------------------
# Model
#--------------------------------------------------------------------------------

class Model extends Backbone.Model
  idAttribute: '_id'
  url:         'comment'
  defaults:
    username:  'my username'
    comment:   ''
    date:      new Date()

#--------------------------------------------------------------------------------
# Pageable Collection
#--------------------------------------------------------------------------------

class PageableCollection extends Backbone.PageableCollection

  url: 'comment'

  model: Model

  state:
    firstPage:   0
    currentPage: 0
    totalRecord: 0
    skip:        0

  queryParams:
    currentPage: "current_page",
    pageSize:    "page_size"

    skip: ->  @state.skip

  comparator: 'date'

#--------------------------------------------------------------------------------
# Composite View
#--------------------------------------------------------------------------------

class CommentView extends Marionette.CompositeView

  template: _.constant ''

  childView: ItemView

  constructor: (options)->
    super
    @mergeOptions options, 'collection'

#--------------------------------------------------------------------------------
# Layout View
#--------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  regions:
    commentRegion: '#comment-region'

  ui:
    panelBody: '.panel-body'
    input:     '#comment-input'
    submit:    '#comment-input-send'

  bindings:

    '#comment-input':
      observe: 'comment'

  events:

    'keyup @ui.input' :(event)->
      if event.keyCode == 13
        @save()
      return

    'click @ui.submit': ->
      @save()
      return

  save: ->

    @model.save {},
      wait: true
      success: (model, response) =>
        @ui.input.val('')
        @collection.add @model.clone()
        @ui.panelBody.scrollTop(@ui.panelBody[0].scrollHeight)
      error: (model, response) ->
        console.log 'error', response

  scrollToBottom: ->
    @ui.panelBody.scrollTop(@ui.panelBody[0].scrollHeight)

  initialize: ->
    @collection = new PageableCollection();

    @collection.fetch
      success: =>
        # Scroll to bottom of panel once finish
        # collecting and composite view is made.

        _.defer () =>
          @scrollToBottom()
      error: ->
        console.log 'Error when fetching comments.'

    @model = new Model()

    console.log 'inits', @model.attributes
    console.log @model


    return

  onRender: ->
    @stickit @model
    return

  onShow: ->

    @showChildView 'commentRegion', new CommentView
      collection: @collection

    return


#--------------------------------------------------------------------------------
# Exports
#--------------------------------------------------------------------------------

module.exports = View

#--------------------------------------------------------------------------------