#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment        = require 'moment'
swal          = require 'sweetalert'
Backbone      = require 'backbone'
Radio         = require 'backbone.radio'
Marionette    = require 'marionette'
Add           = require './add/module'
Edit          = require './edit/module'
HistoryView   = require './history/view'
GraphView     = require './graph/view'
NoteView      = require './note/view'
SummaryView   = require './summary/view'
GoalView      = require './goal/view'
Workout       = require './workout/module'
ChallengeView = require './challenge/view'
CalendarView  = require './calendar/view'
viewTemplate  = require './view.jade'

#-------------------------------------------------------------------------------
# Model
#   cardio model used to fetch data of that exercises
#   such as the name and muscle type.
#-------------------------------------------------------------------------------

class Model extends Backbone.Model
  urlRoot: '/api/cardios'
  idAttribute: '_id'

#-------------------------------------------------------------------------------
# Collection
#-------------------------------------------------------------------------------

class Collection extends Backbone.Collection

  model: Model

  comparator: 'date'

  constructor: (attributes, options) ->
    super
    @url = "/api/cardios/#{options.id}/log"

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  ui:
    add:      '#cardio-detail-add'
    edit:     '#cardio-detail-edit'
    noteView: '#cardio-note-container'
    note:     '#cardio-note'

  regions:
    modal:     '#cardio-modal-view'
    history:   '#cardio-history-view'
    note:      '#cardio-note-view'
    challenge: '#cardio-challenge-view'
    goal:      '#cardio-goal-view'
    summary:   '#cardio-summary-view'
    workout:   '#cardio-workout-view'
    calendar:  '#cardio-calendar-view'
    graph:     '#cardio-graph-view'

  bindings:
    '#cardio-title': 'name'

    '#cardio-note-container':
      observe: 'note'
      visible: (value) -> value

  events:

    'click #home-help': ->
      swal
        title: 'Instructions'
        text:  'Click the "Add Entry" button to add your workout set. Repeat to add more sets.'
      return

    'click #cardio-home': ->
      @rootChannel.request 'home'
      return

    'click #cardio-journals': ->
      @rootChannel.request 'cardios'
      return

    'click #cardio-detail-add': ->
      @channel.request 'add:workout', moment()
      return

    'click #cardio-detail-edit': ->
      @showChildView 'modal', new Edit.View
        model:   @model
        summary: @summaryModel
      return

    'click #cardio-graph-btn': ->
      @rootChannel.request 'log:detail', @model.get('exercise')
      return

    'click #cardio-schedule-btn': ->
      @rootChannel.request 'schedule'
      return

  collectionEvents:
    'sync update': ->
      @summaryModel.update(@model, @collection)
      @updateViews()
      return

  modelEvents:
    'change:date': ->
      @updateAfterDateChange()
      return

    sync: (model) ->
      @summaryModel.update(@model, @collection)
      @updateViews()
      return

  constructor: (options) ->
    super
    @rootChannel = Backbone.Radio.channel('root')
    @mergeOptions options, [
      'cardioID'
      'wLogs'
    ]

    @channel = new Radio.channel(@cid)

    @date = moment()

    @channel.reply

      'add:workout': (date) =>
        @showChildView 'modal', new Add.View
          collection: @collection
          date:       date
          wLogs:      @wLogs
          body:       @model.get 'body'
          model: new Add.Model
            exercise: @model.id
        return

      'change:date': (date) =>
        @date = date
        @updateViews()
        return

    @summaryModel = new Workout.Model {},
      sConf: @model
      sLogs: @collection

  onRender: ->
    @stickit()
    return

  onShow: ->

    #@ui.add.hide() unless Backbone.Radio.channel('user').request 'isOwner'
    #@ui.edit.hide() unless Backbone.Radio.channel('user').request 'isOwner'

    @updateViews()

    if @collection.length is 0
      @channel.request 'add:workout', moment()

    return

  updateAfterDateChange: ->

    @showChildView 'history', new HistoryView
      sLogs:   @collection
      sConf:   @model
      channel: @channel
      date:    @date

    @showChildView 'challenge', new ChallengeView
      sLogs: @collection
      date:  @date
      type:  if @model.get('body') is true then 'rep' else 'weight'

    @showChildView 'goal', new GoalView
      sLogs: @collection
      sConf: @model
      date:  @date
    return

  updateViews: ->

    ###

    @showChildView 'note', new NoteView
      sConf: @model

    @showChildView 'goal', new GoalView
      sLogs: @collection
      date:  @date

    @showChildView 'graph', new GraphView
      sLogs: @collection
      sConf: @model

    @showChildView 'calendar', new CalendarView
      collection: @collection
      type: if @model.get('body') is true then 'rep' else 'weight'

    @showChildView 'summary', new SummaryView
      sLogs: @collection
      sConf: @model

    @showChildView 'workout', new Workout.View
      model: @summaryModel

    @updateAfterDateChange()

###

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
