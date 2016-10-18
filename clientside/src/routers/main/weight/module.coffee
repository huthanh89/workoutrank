#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
moment       = require 'moment'
Backbone     = require 'backbone'
Radio        = require 'backbone.radio'
Marionette   = require 'marionette'
Add          = require './add/module'
Date         = require './date/module'
Table        = require './table/module'
GraphView    = require './graph/view'
Summary      = require './summary/module'
CalendarView = require './calendar/view'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Model
#   Strength model used to fetch data of that exercises
#   such as the name and muscle type.
#-------------------------------------------------------------------------------

class Model extends Backbone.Model
  urlRoot:     '/api/wlogs'
  idAttribute: '_id'

#-------------------------------------------------------------------------------
# Collection
#-------------------------------------------------------------------------------

class Collection extends Backbone.Collection

  model: Model

  comparator: 'date'

  constructor: ->
    super
    @url = "/api/wlogs"

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  ui:
    add:  '#weight-detail-add'

  regions:
    modal:    '#weight-modal-view'
    date:     '#weight-date-view'
    table:    '#weight-table-view'
    graph:    '#weight-graph-view'
    summary:  '#weight-summary-view'
    calendar: '#weight-calendar-view'

  events:

    'click #weight-home': ->
      @rootChannel.request 'home'
      return

    'click #weight-detail-add': ->
      @channel.request 'add'
      return

    'click .weight-body-btn': ->
      @rootChannel.request 'body'
      return

  collectionEvents:
    'sync update': ->
      @updateTableCollection()
      @summaryModel.update(@collection)
      @showCalendar()
      @updateViews()
      return

  modelEvents:
    sync: ->
      @summaryModel.update(@collection)
      @updateViews()
      return

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')

    @dateModel = new Date.Model()

    @channel = new Radio.channel(@cid)
    @channel.reply
      'add': =>
        @addWeight
          date: @dateModel.get('date')
        return

    @tableCollection = new Table.Collection @collection.models
    @updateTableCollection()

    @summaryModel = new Summary.Model {},
      wLogs: @collection

    # When date is changed, update pageable collection.

    @listenTo @dateModel, 'change:date', =>
      @updateTableCollection()
      return

  onShow: ->

    @showChildView 'date', new Date.View
      model: @dateModel

    @showChildView 'table', new Table.View
      collection: @tableCollection
      channel:    @channel

    @showCalendar()

    @ui.add.hide() unless Backbone.Radio.channel('user').request 'isOwner'

    @updateViews()

    if @collection.length is 0
      @channel.request 'add'

    return

  updateViews: ->
    @showChildView 'graph', new GraphView
      sLogs: @collection

    @showChildView 'summary', new Summary.View
      model: @summaryModel
    return

  showCalendar: ->
    @showChildView 'calendar', new CalendarView
      collection: @collection
    return

  addWeight: ->
    @showChildView 'modal', new Add.View
      collection: @collection
      model:      new Add.Model()
      date:       @dateModel.get('date')
    return

  updateTableCollection: ->

    clean = @collection.clone()

    models = @collection.filter (model, index) =>

      # Filter by current day of date.

      dateA  = moment(model.get('date')).startOf('day')
      dateB  = moment(@dateModel.get('date')).startOf('day')
      result = dateA.isSame(dateB)

      if result and (index > 0)
        prev    =  clean.at(index - 1).get('weight')
        current = model.get('weight')
        model.set 'change',  _.round current - prev , 2
        model.set 'percent', _.round (current / prev) * 100 - 100 , 2
      else
        model.set 'change',  0
        model.set 'percent', 0

      return result

    @tableCollection.reset models
    return

  onDestroy: ->
    @channel.reset()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Model      = Model
module.exports.Collection = Collection
module.exports.View       = View

#-------------------------------------------------------------------------------
