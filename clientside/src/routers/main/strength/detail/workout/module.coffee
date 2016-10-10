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
    muscle: []
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
      onGet: (values) ->
        if values.length > 0
          result = []
          for value in values
            result.push _.find(Data.Muscles, value: value).label
          return _.truncate result.toString(),
            length:    20,
            separator: ' '
        else
          return '---'

    '#strength-summary-body':
      observe: 'body'
      updateMethod: 'html'
      onGet: (value) ->
        icon = if value then 'fa-check' else 'fa-ban'
        return "<i class='fa fa-lg #{icon}'></i>"

    '#strength-summary-count': 'count'

    '#strength-summary-note': 'note'

    '#strength-summary-first':
      observe: 'first'
      onGet: (value) -> moment(value).format('MMMM DD, YYYY - dddd')

    '#strength-summary-last':
      observe: 'last'
      onGet: (value) -> moment(value).format('MMMM DD, YYYY - dddd')

  onRender: ->
    @stickit @model
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Model = Model
module.exports.View  = View

#-------------------------------------------------------------------------------
