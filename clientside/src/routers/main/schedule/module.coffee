#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
Data         = require './data/module'
Schedule     = require './schedule/module'
EditView     = require './edit/view'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Model
#-------------------------------------------------------------------------------

class Model extends Backbone.Model

  idAttribute: '_id'

  urlRoot: '/api/schedule'

  defaults:
    sunday:    []
    monday:    []
    tuesday:   []
    wednesday: []
    thursday:  []
    friday:    []
    saturday:  []

#-------------------------------------------------------------------------------
# Collection
#-------------------------------------------------------------------------------

class Collection extends Backbone.Collection

  model: Model

  parse: (response, options) ->

    result = []

    days = [
      'sunday'
      'monday'
      'tuesday'
      'wednesday'
      'thursday'
      'friday'
      'saturday'
    ]

    schedule = _.pick options.schedule.attributes, days

    _.each options.sConfs.models, (model) ->
      for day, index in days
        muscles = model.get('muscle')

        if _.intersection(muscles, schedule[day]).length > 0
          result.push
            start:  new Date moment().startOf('week').add(index, 'days')
            end:    new Date moment().startOf('week').add(index, 'days')
            title:  model.get('name')
            color:  Data.Colors[_.sum(muscles) % Data.Colors.length]
            allDay: true
            strengthID: model.id
      return

    return result

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  regions:
    calendar: '#calendar-view-container'
    modal:    '#schedule-modal-view'

  ui:
    edit:   '#schedule-edit'
    target: '#schedule-target'
    title:  '#schedule-target-title'

  events:
    'click #calendar-home': ->
      @rootChannel.request 'home'
      return

    'click #schedule-edit': ->
      @showChildView 'modal', new EditView
        model:   @model
        channel: @channel
      return

  constructor: (options) ->
    super
    @mergeOptions options, ['sConfs', 'sLogs']
    @rootChannel = Backbone.Radio.channel('root')
    @channel =     new Backbone.Radio.Channel(@cid)

    @channel.reply
      'show:schedule': =>

        @updateLabels()

        collection = new Collection [],
          sLogs:    @sLogs
          sConfs:   @sConfs
          schedule: @model
          parse:    true

        events = collection.toJSON()

        @showChildView 'calendar', new Schedule.View
          channel:        @channel
          model:          @model
          calendarEvents: events
          sLogs:          @sLogs
        return

  onShow: ->
    @channel.request 'show:schedule'
    return

  updateLabels: ->

    console.log @model.get('tuesday')

    day    = moment().format('dddd').toLowerCase()
    values = @model.get(day)
    text   = 'No muscle group today.'
    result = []

    for value in values
      result.push _.find(Data.Muscles, value: value).label

    if result.length
      text = result.join(', ')

    @ui.target.html text
    @ui.title.html moment().format('dddd') + '\'s Workout'

    return

  onBeforeDestroy: ->
    @channel.reset()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

exports.Model      = Model
exports.Collection = Collection
exports.View       = View

#-------------------------------------------------------------------------------
