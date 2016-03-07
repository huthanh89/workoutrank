#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Backbone     = require 'backbone'
Marionette   = require 'marionette'
InputView    = require './input/view'
TableView    = require './table/view'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView
  template: viewTemplate

  regions:
    input: '#exercise-strength-input-view'
    table: '#exercise-strength-table-view'

  events:
    'click #exercise-strength-back': ->
      @rootChannel.request('exercise')
      return

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')

  onShow: ->
    @showChildView 'input', new InputView
      model: @model

    #@showChildView 'table', new TableView
    #  collection: @collection

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
