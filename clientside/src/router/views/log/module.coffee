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

  defaults:
    name: ''
    data: []

#-------------------------------------------------------------------------------
# Collection
#-------------------------------------------------------------------------------

class Collection extends Backbone.Collection

  url: '/api/log'

  ###
  parse: (response) ->

    series = {}

    for record in response.log
      _.each record.session, (session, index) ->
        series[session.index] = [] if series[session.index] is undefined
        series[session.index].push
          x: moment(record.date).valueOf()
          y: session.weight
        return

    result = []

    for key, serie of series
      result.push {
        index: key
        name: "SET#{key}"
        data: serie or []
      }

    response.log = result

    return response

###

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  regions:
    graph: '#strength-log-graph-view'
    table: '#strength-log-table-view'

  events:
    'click #strength-log-back': ->
      @rootChannel.request 'strength:detail', @strengthID
      return

  constructor: (options) ->
    super
    @rootChannel = Backbone.Radio.channel('root')
    @mergeOptions options, 'strengthID'

  onRender: ->
    @stickit()
    return

  onShow: ->

    #@showChildView 'graph', new GraphView
    #  collection: new Backbone.Collection @model.get('log')
    #  model: @model

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Model      = Model
module.exports.Collection = Collection
module.exports.View       = View

#-------------------------------------------------------------------------------
