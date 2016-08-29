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
    summary:  '#weight-summary-view'
    calendar: '#weight-calendar-view'

  events:

    'click #weight-home': ->
      @rootChannel.request 'home'
      return

    'click #weight-journals': ->
      @rootChannel.request 'weights'
      return

    'click #weight-detail-add': ->
      @channel.request 'add'
      return

    'click #weight-graph-btn': ->
      @rootChannel.request 'log:detail', @model.get('exercise')
      return

    'click #weight-calendar-btn': ->
      @rootChannel.request 'calendar'
      return

    'click #weight-schedule-btn': ->
      @rootChannel.request 'schedule'
      return

  collectionEvents:
    'sync update': ->
      @updatePageableCollection()
      @summaryModel.update(@collection)
      @showCalendar()
      return

  modelEvents:
    sync: (model) ->
      @summaryModel.update(@collection)
      return

  constructor: (options) ->
    super
    @rootChannel = Backbone.Radio.channel('root')

    @dateModel = new Date.Model()

    @channel = new Radio.channel(@cid)
    @channel.reply
      'add': =>
        @addWeight
          date: @dateModel.get('date')
        return

    @pageableCollection = new Table.Collection @collection.models

    @summaryModel = new Summary.Model {},
      wLogs: @collection

    # When date is changed, update pageable collection.

    @listenTo @dateModel, 'change:date', =>
      @updatePageableCollection()
      return

  onShow: ->

    @showChildView 'date', new Date.View
      model: @dateModel

    @showChildView 'table', new Table.View
      collection: @pageableCollection
      channel:    @channel

    @showChildView 'summary', new Summary.View
      model: @summaryModel

    @showCalendar()

    @ui.add.hide() unless Backbone.Radio.channel('user').request 'isOwner'

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

  updatePageableCollection: ->
    models = @collection.filter (model) =>
      dateA = moment(model.get('date')).startOf('day')
      dateB = moment(@dateModel.get('date')).startOf('day')
      return dateA.isSame(dateB)
    @pageableCollection.fullCollection.reset models
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