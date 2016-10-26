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
    name:   ''
    muscle: []
    count:  0
    body:   false
    first:  new Date()
    last:   new Date()
    note:   ''

  constructor: (attributes, options) ->
    super
    @update options.cConf, options.cLogs

  update: (cConf, cLogs) =>
    @set
      name:   cConf.get('name')
      muscle: cConf.get('muscle')
      body:   cConf.get('body')
      note:   cConf.get('note')
      count:  cLogs.length
      first:  if cLogs.length then firstDate(cLogs) else null
      last:   if cLogs.length then lastDate(cLogs) else  null
    return

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  ui:
    body: '#cardio-summary-body'

  bindings:

    '#cardio-summary-name': 'name'

    '#cardio-summary-body':
      observe: 'body'
      updateMethod: 'html'
      onGet: (value) ->
        icon = if value then 'fa-check' else 'fa-ban'
        return "<i class='fa fa-lg #{icon}'></i>"

    '#cardio-summary-count': 'count'

    '#cardio-summary-first':
      observe: 'first'
      onGet: (value) -> if value then moment(value).from moment() else '---'

    '#cardio-summary-last':
      observe: 'last'
      onGet: (value) -> if value then moment(value).from moment() else '---'

  onRender: ->
    @stickit @model
    return

  onBeforeDestroy: ->
    @unstickit()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Model = Model
module.exports.View  = View

#-------------------------------------------------------------------------------
