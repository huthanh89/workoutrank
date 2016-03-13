#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
GraphView    = require './graph/view'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Model
#-------------------------------------------------------------------------------

class Model extends Backbone.Model

  idAttribute: '_id'

  constructor: (attributes, options) ->
    super
    @url = "/api/strength/#{options.id}/log"

  parse: (response) -> response

#-------------------------------------------------------------------------------
# Collection
#-------------------------------------------------------------------------------

class Collection extends Backbone.Collection

  model: Model

  constructor: (attributes, options) ->
    super
    @url = "/api/strength/#{options.id}/log"

  comparator: (item) -> return -item.get('date')

  parse: (response) ->

    series = []
    for record in response
      _.each record.session, (session, index) ->
        series[session.index] = [] if series[session.index] is undefined
        series[session.index].push
          name: record.name
          x:    moment(session.date).valueOf()
          y:    session.weight
        return

    result = []
    for serie, index in series
      result.push {
        name: "Set #{index}"
        data: serie
      }

    console.log 'RESULT', result

    return result

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView
  template: viewTemplate

  regions:
    graph: '#strength-graph-view'

  events:
    'click #strength-back': ->
      @rootChannel.request 'strength'
      return

    'click #strength-log': ->
      @rootChannel.request 'strength:log', @strengthID
      return

  constructor: (options) ->
    super
    @rootChannel = Backbone.Radio.channel('root')

  onShow: ->
    @showChildView 'graph', new GraphView
      collection: @collection
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Model      = Model
module.exports.Collection = Collection
module.exports.View       = View

#-------------------------------------------------------------------------------
