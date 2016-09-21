#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

$            = require 'jquery'
moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
Data         = require '../data/module'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  ui:
    dialog:    '#calendar-modal-dialog'
    sunday:    '#calendar-modal-sunday'
    monday:    '#calendar-modal-monday'
    tuesday:   '#calendar-modal-tuesday'
    wednesday: '#calendar-modal-wednesday'
    thursday:  '#calendar-modal-thursday'
    friday:    '#calendar-modal-friday'
    saturday:  '#calendar-modal-saturday'

  events:

    'submit': (event) ->
      event.preventDefault()

      @model.set
        sunday:    @ui.sunday.val() or []
        monday:    @ui.monday.val() or []
        tuesday:   @ui.tuesday.val() or []
        wednesday: @ui.wednesday.val() or []
        thursday:  @ui.thursday.val() or []
        friday:    @ui.friday.val() or []
        saturday:  @ui.saturday.val() or []

      @model.save [],
        success:  =>
          @saved = true
          @ui.dialog.modal('hide')
          return
        error: (model, response) =>
          @rootChannel.request 'message:error', response
          return

      return

    'hidden.bs.modal': ->
      @ui.sunday.multiselect('destroy')
      @ui.monday.multiselect('destroy')
      @ui.tuesday.multiselect('destroy')
      @ui.wednesday.multiselect('destroy')
      @ui.thursday.multiselect('destroy')
      @ui.friday.multiselect('destroy')
      @ui.saturday.multiselect('destroy')
      if @saved
        @channel.request 'show:schedule'
      return

  constructor: (options) ->
    super
    @mergeOptions options, 'channel'
    @rootChannel = Backbone.Radio.channel('root')

  onRender: ->

    @createSelect('sunday')
    @createSelect('monday')
    @createSelect('tuesday')
    @createSelect('wednesday')
    @createSelect('thursday')
    @createSelect('friday')
    @createSelect('saturday')

    # Show this dialog

    @ui.dialog.modal
      backdrop: 'static'
      keyboard: false

    return

  createSelect: (day) ->
    @ui[day].multiselect
      includeSelectAllOption: true
      maxHeight:     450
      buttonWidth:  '100%'
      buttonClass:  'btn btn-default'
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
