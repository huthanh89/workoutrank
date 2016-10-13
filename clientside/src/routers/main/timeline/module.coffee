#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
Strength     = require './strength/module'
Weight       = require './weight/module'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# SLogs Collection
#-------------------------------------------------------------------------------

class SLogCollection extends Backbone.Collection
  url: 'api/slogs'

#-------------------------------------------------------------------------------
# Collection
#-------------------------------------------------------------------------------

class Collection extends Backbone.Collection

  comparator: (model) -> -moment(model.get('date')).utc()

  parse: (response, options) ->

    sConfs = options.sConfs

    result = []

    for model in options.sLogs.models

      sConf = sConfs.get(model.get('exercise'))

      if sConf
        result.push _.extend {}, model.attributes,
          type: 'strength'
          name: sConf.get('name')

    for model in options.wLogs.models
      result.push _.extend {}, model.attributes,
        type: 'weight'

    return result

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.CompositeView

  template: viewTemplate

  serializeData: -> {}

  childViewContainer: '#timeline-view'

  getChildView: (model) ->
    return if model.get('type') is 'strength' then Strength.View else Weight.View

  events:
    'click #timeline-home':  ->
      @rootChannel.request 'home'
      return

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.SLogCollection = SLogCollection
module.exports.Collection     = Collection
module.exports.View           = View

#-------------------------------------------------------------------------------
