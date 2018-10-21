#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
moment       = require 'moment'
Backbone     = require 'backbone'
Radio        = require 'backbone.radio'
Marionette   = require 'backbone.marionette'
viewTemplate = require './view.pug'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'backbone.stickit'

#-------------------------------------------------------------------------------
# Channels
#-------------------------------------------------------------------------------

userChannel = Radio.channel('user')

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
    min:           0
    max:           0
    avg:           0
    count:         0
    firstDate:     0
    lastDate:      0
    currentWeight: 0


  parse: (attributes, options) ->

    wLogs    = options.wLogs

    if wLogs.length is 0
      return {
        min:   0
        max:   0
        avg:   0
        count: 0
        firstDate:     null
        lastDate:      null
        currentWeight: null
      }

    minModel = _.minBy  wLogs.models, (model) -> model.get('weight')
    maxModel = _.maxBy  wLogs.models, (model) -> model.get('weight')
    avg      = _.meanBy wLogs.models, (model) -> model.get('weight')
    round    = 1

    model = latestModel wLogs

    return {
      min: _.round minModel.get('weight'), round
      max: _.round maxModel.get('weight'), round
      avg: _.round avg, round
      count:         wLogs.length
      firstDate:     if wLogs.length then firstDate(wLogs)  else null
      lastDate:      if wLogs.length then model.get('date') else null
      currentWeight: if model then model.get('weight')      else null
    }

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.View

  template: viewTemplate

  bindings:

    '#body-reduce-min':
      observe: 'min'
      onGet: (value) -> value + ' lb'

    '#body-reduce-max':
      observe: 'max'
      onGet: (value) -> value + ' lb'

    '#body-reduce-avg':
      observe: 'avg'
      onGet: (value) -> value + ' lb'

    '#body-reduce-count': 'count'

    '#body-reduce-first':
      observe: 'firstDate'
      onGet: (value) -> if value then moment(value).from moment() else '---'

    '#body-reduce-last':
      observe: 'lastDate'
      onGet: (value) -> if value then moment(value).from moment() else '---'

    '#body-reduce-current-weight':
      observe: 'currentWeight'
      onGet: (value) -> value + ' lb'


    '#body-reduce-bmi':
      observe: 'currentWeight'
      onGet: (value) ->
        user   = userChannel.request('user')
        height = user.get('height')

        return 'n/a' if height is 0

        weight = value
        bmi    = _.round ((weight / (height * height)) * 703), 2
        text   = ''

        switch
          when (bmi <  18.5)  then text = 'Underweight'
          when (18.5  < bmi <= 24.90) then text = 'Normal Weight'
          when (24.90 < bmi <= 29.90) then text = 'Overweight'
          else text = 'Overweight'

        return "#{bmi} (#{text})"
        
  constructor: (options) ->

    model = new Model {},
      wLogs: options.wLogs
      parse: true

    super _.extend options,
      model: model

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
