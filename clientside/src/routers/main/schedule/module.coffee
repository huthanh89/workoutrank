#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
moment       = require 'moment'
swal         = require 'sweetalert'
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

    'click #schedule-help': ->
      swal
        title: 'Instructions'
        text:  'Click the "Edit Schedule" button to edit your schedule. Note: The schedule will automatically be populated after you\'ve created some workouts.'
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
    @channel     = new Backbone.Radio.Channel(@cid)

    @channel.reply

      'update:label': (day) =>
        @updateLabels(day)
        return

      'show:schedule': =>

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

  # update workout daily muscle labels.

  updateLabels: (dayNumber) ->

    day    = moment().startOf('week').add(dayNumber - 1, 'days').format('dddd').toLowerCase()
    values = @model.get(day)
    text   = 'No muscle group assigned for today.'
    result = []

    for value in values
      result.push _.find(Data.Muscles, value: value).label

    if result.length
      text = result.join(', ')
      @ui.target.css 'color', '#5a646b'
    else
      @ui.target.css 'color', '#68a7d6'

    titleDay = day.charAt(0).toUpperCase() + day.slice(1).toLowerCase()

    @ui.target.html text
    @ui.title.text titleDay + '\'s Schedule'

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
