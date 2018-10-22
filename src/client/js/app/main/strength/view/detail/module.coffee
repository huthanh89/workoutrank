#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment        = require 'moment'
swal          = require 'sweetalert'
Backbone      = require 'backbone'
Radio         = require 'backbone.radio'
Marionette    = require 'backbone.marionette'
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
viewTemplate  = require './view.pug'

#-------------------------------------------------------------------------------
# Channels
#-------------------------------------------------------------------------------

rootChannel = Radio.channel('root')

#-------------------------------------------------------------------------------
# Model
#   Strength model used to fetch data of that exercises
#   such as the name and muscle type.
#-------------------------------------------------------------------------------

class Model extends Backbone.Model
  urlRoot:     '/api/strengths'
  idAttribute: '_id'

#-------------------------------------------------------------------------------
# Collection
#-------------------------------------------------------------------------------

class Collection extends Backbone.Collection

  model: Model

  comparator: 'date'

  constructor: (attributes, options) ->
    super(attributes, options)
    @url = "/api/strengths/#{options.id}/log"

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.View

  template: viewTemplate

  ui:
    add:      '#strength-detail-add'
    edit:     '#strength-detail-edit'
    noteView: '#strength-note-container'
    note:     '#strength-note'

  regions:
    modal:     '#strength-modal-view'
    history:   '#strength-history-view'
    note:      '#strength-note-view'
    challenge: '#strength-challenge-view'
    goal:      '#strength-goal-view'
    summary:   '#strength-summary-view'
    workout:   '#strength-workout-view'
    calendar:  '#strength-calendar-view'
    graph:     '#strength-graph-view'

  bindings:
    '#strength-title': 'name'

    '#strength-note-container':
      observe: 'note'
      visible: (value) -> value

  events:

    'click #home-help': ->
      swal
        title: 'Instructions'
        text:  'Click the "Add Entry" button to add your workout set. Repeat to add more sets.'
      return

    'click #strength-home': ->
      rootChannel.request 'home'
      return

    'click #strength-journals': ->
      rootChannel.request 'strengths'
      return

    'click #strength-detail-add': ->
      @channel.request 'add:workout', moment()
      return

    'click #strength-detail-edit': ->
      @showChildView 'modal', new Edit.View
        model:   @model
        summary: @summaryModel
      return

    'click #strength-graph-btn': ->
      rootChannel.request 'log:detail', @model.get('exercise')
      return

    'click #strength-schedule-btn': ->
      rootChannel.request 'schedule'
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

    sync: ->
      @summaryModel.update(@model, @collection)
      @updateViews()
      return

  constructor: (options) ->
    super(options)
    @mergeOptions options, [
      'strengthID'
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

  onAttach: ->

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

    return

  updateViews: ->

    @showChildView 'note', new NoteView
      sConf: @model

    @showChildView 'goal', new GoalView
      sLogs: @collection
      sConf: @model
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
