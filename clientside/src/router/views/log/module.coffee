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

  parse: (response) ->
    result = []

    grouped = _.groupBy response, (record) -> record.muscle

    for key, records of grouped

      data = []
      console.log key, records

      for record in records

        data.push _.map record.session, (set) ->
          return {
            x: moment(record.date).valueOf()
            y: set.weight
          }

      result.push
        muscle: parseInt(key)
        data:   data

    console.log 'RESULT', result

    return result

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  regions:
    graph: '#log-graph-view'
    table: '#log-table-view'

  events:
    'click #log-home': ->
      @rootChannel.request 'home'
      return

  constructor: (options) ->
    super
    @rootChannel = Backbone.Radio.channel('root')

  onRender: ->
    @stickit()
    return

  onShow: ->

    console.log @collection

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