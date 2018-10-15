#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
Marionette   = require 'backbone.marionette'
DateView     = require './date/view'
TableView    = require './table/view'
viewTemplate = require './view.pug'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.View

  template: viewTemplate

  regions:
    date:  '#strength-date-container'
    table: '#strength-table-container'

  constructor: (options) ->
    super
    @mergeOptions options, [
      'channel'
      'sLogs'
      'sConf'
      'date'
    ]

  onAttach: ->

    @showChildView 'date', new DateView
      date:    @date
      channel: @channel

    @showChildView 'table', new TableView
      sLogs:   @sLogs
      channel: @channel
      date:    @date
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
