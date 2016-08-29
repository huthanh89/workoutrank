#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'backbone.stickit'

#-------------------------------------------------------------------------------
# Given an array of models, return the oldest date.
#-------------------------------------------------------------------------------

firstDate = (collection) ->
  model = _.minBy collection.models, (model) -> model.get('date')
  return model.get('date')

#-------------------------------------------------------------------------------
# Given an array of models, return the latest date.
#-------------------------------------------------------------------------------

lastDate = (collection) ->
  model = _.maxBy collection.models, (model) -> model.get('date')
  return model.get('date')

#-------------------------------------------------------------------------------
# Model
#-------------------------------------------------------------------------------

class Model extends Backbone.Model

  idAttribute: '_id'

  defaults:
    weight: 0
    count:  0
    first:  new Date()
    last:   new Date()

  constructor: (attributes, options) ->
    super
    @update options.wLogs

  update: (wLogs) =>
    @set
      count:  wLogs.length
      first:  if wLogs.length then firstDate(wLogs) else null
      last:   if wLogs.length then lastDate(wLogs) else null
    return

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  bindings:

    '#weight-summary-count': 'count'

    '#weight-summary-first':
      observe: 'first'
      onGet: (value) -> if value is null then '---' else moment(value).format('ddd YYYY/MM/DD')

    '#weight-summary-last':
      observe: 'last'
      onGet: (value) -> if value is null then '---' else moment(value).format('ddd YYYY/MM/DD')

  onRender: ->
    @stickit @model
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Model = Model
module.exports.View  = View

#-------------------------------------------------------------------------------
