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
    super
    @update options.wLogs

  update: (wLogs) =>

    model = latestModel wLogs

    @set
      count:         wLogs.length
      firstDate:     if wLogs.length then firstDate(wLogs)  else null
      lastDate:      if wLogs.length then model.get('date') else null
      currentWeight: if model then model.get('weight')      else null
    return

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  bindings:

    '#body-summary-count': 'count'

    '#body-summary-first':
      observe: 'firstDate'
      onGet: (value) -> if value then moment(value).from moment() else '---'

    '#body-summary-last':
      observe: 'lastDate'
      onGet: (value) -> if value then moment(value).from moment() else '---'

    '#body-summary-current-weight':
      observe: 'currentWeight'
      onGet: (value) -> value + ' lb'


    '#body-summary-bmi':
      observe: 'currentWeight'
      onGet: (value) ->
        height = @userChannel.get('height')
        weight = value
        bmi    = _.round ((weight / (height * height)) * 703), 2
        text   = ''

        switch
          when (bmi <  18.5)  then text = 'Underweight'
          when (18.5  < bmi <= 24.90) then text = 'Normal Weight'
          when (24.90 < bmi <= 29.90) then text = 'Overweight'
          else text = 'Overweight'

        return "#{bmi} (#{text})"

  constructor: ->
    super
    @userChannel = Backbone.Radio.channel('user').request('user')

  onRender: ->
    @stickit @model
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Model = Model
module.exports.View  = View

#-------------------------------------------------------------------------------
