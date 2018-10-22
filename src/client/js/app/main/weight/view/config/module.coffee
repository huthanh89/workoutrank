#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'backbone.marionette'
viewTemplate = require './view.pug'

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

latestModel = (collection) -> _.maxBy collection.models, (model) -> model.get('date')

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
    super(attributes, options)
    @update options.wLogs

  update: (wLogs) =>

    model = latestModel(wLogs)

    @set
      count:      wLogs.length
      firstDate:  if wLogs.length then firstDate(wLogs)  else null
      lastDate:   if wLogs.length then model.get('date') else null
      lastWeight: if model then model.get('weight')      else null

    return

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.View

  template: viewTemplate

  bindings:

    '#weight-summary-count': 'count'

    '#weight-summary-first':
      observe: 'firstDate'
      onGet: (value) -> if value is null then '---' else moment(value).format('ddd YYYY/MM/DD')

    '#weight-summary-last':
      observe: 'lastDate'
      onGet: (value) -> if value is null then '---' else moment(value).format('ddd YYYY/MM/DD')

    '#weight-summary-current-weight':
      observe: 'lastWeight'
      onGet: (value) -> value + ' lb'


    '#weight-summary-bmi':
      observe: 'lastWeight'
      onGet: (value) ->
        height = @userChannel.get('height')
        weight = value
        bmi = _.round ((weight / (height * height)) * 703), 2
        return bmi

  constructor: (options) ->
    super(options)
    @userChannel = Backbone.Radio.channel('user').request('user')

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
