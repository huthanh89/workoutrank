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
# Plugins
#-------------------------------------------------------------------------------

require 'backbone.stickit'
require 'bootstrap.datetimepicker'

#-------------------------------------------------------------------------------
# Model
#-------------------------------------------------------------------------------

class Model extends Backbone.Model

  idAttribute: '_id'

  defaults:
    sunday:    []
    monday:    []
    tuesday:   []
    wednesday: []
    thursday:  []
    friday:    []
    saturday:  []

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
        sunday:    @ui.sunday.val()
        monday:    @ui.monday.val()
        tuesday:   @ui.tuesday.val()
        wednesday: @ui.wednesday.val()
        thursday:  @ui.thursday.val()
        friday:    @ui.friday.val()
        saturday:  @ui.saturday.val()

      @model.save [],
        success:  =>
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
      return

  constructor: (options) ->
    super
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

    @ui.dialog.modal()

    return

  createSelect: (day) ->
    @ui[day].multiselect
      maxHeight:     450
      buttonWidth:  '100%'
      buttonClass:  'btn btn-default'
      dropRight:     true
    .multiselect 'dataprovider', Data.Muscles
    .multiselect('select', @model.get(day))
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Model = Model
module.exports.View  = View

#-------------------------------------------------------------------------------
