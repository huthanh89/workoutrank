#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
Data         = require '../../data/module'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  bindings:

    '#strength-log-table-name': 'name'

    '#strength-log-table-max':
      observe: 'max'
      onGet: (value) -> value + ' lb'

    '#strength-log-table-min':
      observe: 'min'
      onGet: (value) -> value + ' lb'

    '#strength-log-table-avg': 'avg'

    '#strength-log-table-target':
      observe: 'muscle'
      onGet: (value) -> _.find(Data.Muscles, value: value).label

    '#strength-log-table-date':
      observe: 'date'
      onGet: (value) -> moment(value).format('YYYY-MM-DD')

  constructor: (options) ->
    super
    @rootChannel = Backbone.Radio.channel('root')
    @mergeOptions options, 'title'

  onRender: ->
    @stickit()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
