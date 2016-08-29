#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
moment       = require 'moment'
Backbone     = require 'backbone'
Radio        = require 'backbone.radio'
Marionette   = require 'marionette'
Add          = require './add/module'
Edit         = require './edit/module'
DateView     = require './date/view'
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

  urlRoot: '/api/strengths'

  idAttribute: '_id'

#-------------------------------------------------------------------------------
# Collection
#-------------------------------------------------------------------------------

class Collection extends Backbone.Collection

  model: Model

  comparator: 'date'

  constructor: (attributes, options) ->
    super
    @url = "/api/strengths/#{options.id}/log"

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  ui:
    add:  '#strength-detail-add'
    edit: '#strength-detail-edit'

  regions:
    modal:    '#strength-modal-view'
    date:     '#strength-date-view'
    table:    '#strength-table-view'
    summary:  '#strength-summary-view'
    calendar: '#strength-calendar-view'

  bindings:
    '#strength-title': 'name'

  events:

    'click #strength-home': ->
      @rootChannel.request 'home'
      return

    'click #strength-journals': ->
      @rootChannel.request 'strengths'
      return

    'click #strength-detail-add': ->
      @channel.request 'add'
      return

    'click #strength-detail-edit': ->
      @showChildView 'modal', new Edit.View
        model:   @model
        summary: @summaryModel
      return

    'click #strength-graph-btn': ->
      @rootChannel.request 'log:detail', @model.get('exercise')
      return

    'click #strength-calendar-btn': ->
      @rootChannel.request 'calendar'
      return

    'click #strength-schedule-btn': ->
      @rootChannel.request 'schedule'
      return

  collectionEvents:
    'sync update': ->
      @updatePageableCollection()
      @summaryModel.update(@model, @collection)
      @showCalendar()
      return

  modelEvents:
    sync: (model) ->
      @summaryModel.update(@model, @collection)
      return

  constructor: (options) ->
    super
    @rootChannel = Backbone.Radio.channel('root')
    @mergeOptions options, [
      'strengthID'
      'wLogs'
    ]

    attributes = _.chain @model.attributes
      .extend
        date:     new Date()
        exercise: @model.get('_id')
      .omit '_id'
      .value()

    @channel = new Radio.channel(@cid)

    @channel.reply
      'add': =>
        @addWorkout
          date: @model.get('date')
        return

    @pageableCollection = new Table.Collection @collection.models
    @updatePageableCollection()

    @summaryModel = new Summary.Model {},
      sConf: @model
      sLogs: @collection

    # When date is changed, update pageable collection.

    @listenTo @model, 'change:date', =>
      @updatePageableCollection()
      return

  onRender: ->
    @stickit()
    return

  onShow: ->

    @showChildView 'date', new DateView
      model: @model

    @showChildView 'table', new Table.View
      collection: @pageableCollection
      channel:    @channel

    @showChildView 'summary', new Summary.View
      model: @summaryModel

    @showCalendar()

    @ui.add.hide() unless Backbone.Radio.channel('user').request 'isOwner'
    @ui.edit.hide() unless Backbone.Radio.channel('user').request 'isOwner'

    return

  showCalendar: ->
    @showChildView 'calendar', new CalendarView
      collection: @collection
    return

  addWorkout: ->
    @showChildView 'modal', new Add.View
      collection: @collection
      model:      new Add.Model _.omit(@model.attributes, '_id')
      date:       @model.get('date')
      wLogs:      @wLogs
    return

  updatePageableCollection: ->
    models = @collection.filter (model) =>
      dateA = moment(model.get('date')).startOf('day')
      dateB = moment(@model.get('date')).startOf('day')
      return dateA.isSame(dateB)
    @pageableCollection.reset models
    return

  onBeforeDestroy: ->
    @unstickit()
    @channel.reset()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Model      = Model
module.exports.Collection = Collection
module.exports.View       = View

#-------------------------------------------------------------------------------
