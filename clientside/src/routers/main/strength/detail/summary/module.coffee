#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
Data         = require '../../data/module'
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
    name:   ''
    muscle: 0
    count:  0
    body:   false
    first:  new Date()
    last:   new Date()
    note:   ''

  constructor: (attributes, options) ->
    super
    @update options.sConf, options.sLogs

  update: (sConf, sLogs) =>
    @set
      name:   sConf.get('name')
      muscle: sConf.get('muscle')
      body:   sConf.get('body')
      note:   sConf.get('note')
      count:  sLogs.length
      first:  if sLogs.length then firstDate(sLogs) else sConf.get('date')
      last:   if sLogs.length then lastDate(sLogs) else sConf.get('date')
    return

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  ui:
    body: '#strength-summary-body'

  bindings:

    '#strength-summary-name': 'name'

    '#strength-summary-muscle':
      observe: 'muscle'
      onGet: (value) -> _.find(Data.Muscles, value:value).label

    '#strength-summary-count': 'count'

    '#strength-summary-note': 'note'

    '#strength-summary-first':
      observe: 'first'
      onGet: (value) -> moment(value).format('ddd YYYY/MM/DD')

    '#strength-summary-last':
      observe: 'last'
      onGet: (value) -> moment(value).format('ddd YYYY/MM/DD')

  onRender: ->
    @ui.body.prop('checked', @model.get('body'))
    @stickit @model
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Model = Model
module.exports.View  = View

#-------------------------------------------------------------------------------
