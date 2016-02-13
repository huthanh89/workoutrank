#--------------------------------------------------------------------------------
# Imports
#--------------------------------------------------------------------------------

_            = require 'lodash'
$            = require 'jquery'
async        = require 'async'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
ItemView     = require './item/view'
viewTemplate = require './view.jade'

#--------------------------------------------------------------------------------
# Model
#--------------------------------------------------------------------------------

class Model extends Backbone.Model
  defaults:
    input: 'alien'
    limit: 10

#--------------------------------------------------------------------------------
# View
#--------------------------------------------------------------------------------

class View extends Marionette.CompositeView

  template: viewTemplate

  childView: ItemView

  bindings:
    '#movies-search':
      observe: 'input'

  events:
    'keyup #movies-search': (event) ->
      if event.keyCode is 13
        @queryTitle(@model.get('input'))

      return

  initialize: ->
    @model = new Model()

    @queryTitle(@model.get('input'))

  onRender: ->
    @stickit @model

  queryTitle: (_title) ->

    title = encodeURI(_title)

    async.waterfall [

      (callback) =>
        $.ajax
          url: 'http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=6a7k9p7zwa8kajbhbwzbw6hn&q=' + title + '&page_limit=' + @model.get('limit')
          cache: false
          crossDomain: true
          dataType: 'jsonp'
          success: (result) =>
            @collection.reset result.movies
            return callback null
    ], (err) ->
      return
    return


#--------------------------------------------------------------------------------
# Exports
#--------------------------------------------------------------------------------

module.exports = View

#--------------------------------------------------------------------------------