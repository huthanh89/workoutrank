#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
Marionette   = require 'backbone.marionette'
DateView     = require './date/view'
TableView    = require './table/view'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.View

  template: viewTemplate

  regions:
    date:  '#cardio-date-container'
    table: '#cardio-table-container'

  constructor: (options) ->
    super
    @mergeOptions options, [
      'channel'
      'cLogs'
      'cConf'
      'date'
    ]

  onAttach: ->

    @showChildView 'date', new DateView
      date:    @date
      channel: @channel

    @showChildView 'table', new TableView
      cLogs:   @cLogs
      channel: @channel
      date:    @date
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
