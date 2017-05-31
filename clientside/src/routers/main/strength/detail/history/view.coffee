#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
Backbone     = require 'backbone'
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
    date:  '#strength-date-container'
    table: '#strength-table-container'

  constructor: (options) ->
    super
    @rootChannel = Backbone.Radio.channel('root')
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
