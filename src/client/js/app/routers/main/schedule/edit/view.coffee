#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

$            = require 'jquery'
moment       = require 'moment'
Radio        = require 'backbone.radio'
Marionette   = require 'backbone.marionette'
Data         = require '../data/module'
viewTemplate = require './view.pug'

#-------------------------------------------------------------------------------
# Channels
#-------------------------------------------------------------------------------

rootChannel = Radio.channel('root')

#-------------------------------------------------------------------------------
# Day Array
#-------------------------------------------------------------------------------

Days = [
  'sunday'
  'monday'
  'tuesday'
  'wednesday'
  'thursday'
  'friday'
  'saturday'
]

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.View

  template: viewTemplate

  ui:
    dialog:    '#calendar-modal-dialog'

    sundayStrength:    '#calendar-modal-sunday'
    mondayStrength:    '#calendar-modal-monday'
    tuesdayStrength:   '#calendar-modal-tuesday'
    wednesdayStrength: '#calendar-modal-wednesday'
    thursdayStrength:  '#calendar-modal-thursday'
    fridayStrength:    '#calendar-modal-friday'
    saturdayStrength:  '#calendar-modal-saturday'

    sundayCardio:    '#calendar-modal-sunday-cardio'
    mondayCardio:    '#calendar-modal-monday-cardio'
    tuesdayCardio:   '#calendar-modal-tuesday-cardio'
    wednesdayCardio: '#calendar-modal-wednesday-cardio'
    thursdayCardio:  '#calendar-modal-thursday-cardio'
    fridayCardio:    '#calendar-modal-friday-cardio'
    saturdayCardio:  '#calendar-modal-saturday-cardio'

  events:

    'submit': (event) ->
      event.preventDefault()

      # Set schedule.

      for day in Days

        schedule = @ui["#{day}Strength"].val() or []

        if  @ui["#{day}Cardio"].is(':checked')
          schedule = _.union schedule, [-1]
        else
          schedule = _.difference schedule, [-1]

        schedule = _.map schedule, (day) -> parseInt day

        @model.set day, schedule

      # Save schedule.

      @model.save [],
        success:  =>
          @saved = true
          @ui.dialog.modal('hide')
          return
        error: (model, response) ->
          rootChannel.request 'message:error', response
          return

      return

    'hidden.bs.modal': ->

      for day in Days
        @ui["#{day}Strength"].multiselect('destroy')

      if @saved
        @channel.request 'show:schedule'
      return

  constructor: (options) ->
    super(options)
    @mergeOptions options, [
      'channel'
    ]

  onRender: ->

    for day in Days
      @createSelect(day)

      schedule = @model.get day
      @ui["#{day}Cardio"].prop 'checked', _.indexOf(schedule, -1) isnt -1

    # Show this dialog

    @ui.dialog.modal
      backdrop: 'static'
      keyboard: false

    return

  createSelect: (day) ->

    @ui["#{day}Strength"].multiselect
      includeSelectAllOption: true
      maxHeight:     200
      buttonWidth:  '100%'
      buttonClass:  'btn btn-default'
      nonSelectedText: 'Strength Training'
      dropRight:     true
    .multiselect 'dataprovider', Data.Muscles
    .multiselect('select', @model.get(day))
    return

  onBeforeDestroy: ->
    $('.modal-backdrop').remove()
    $('body').removeClass 'modal-open'
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
