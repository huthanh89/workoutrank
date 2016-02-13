#--------------------------------------------------------------------------------
# Imports
#--------------------------------------------------------------------------------

_            = require 'lodash'
$            = require 'jquery'
moment       = require 'moment'
Backbone     = require 'backbone'
Radio        = require 'backbone.radio'
Marionette   = require 'marionette'
App          = require 'client/webapp'
viewTemplate = require './view.jade'

require 'stickit'

#--------------------------------------------------------------------------------
# Item View
#--------------------------------------------------------------------------------

class View extends Marionette.ItemView
  template: viewTemplate

  bindings:

    '.movie-thumbnail':
      observe: 'id'
      updateMethod: 'html'
      onGet: ->
        posters = @model.get('posters')
        return '<img src=' + posters['profile'] + '></img>' unless not posters
        return '<img></img>'

    '.movie-title':
      observe: 'title'
      onGet: (value) ->
        return value + ' (' + @model.get('year') + ')'

    '.movie-synopsis':
      observe: 'synopsis'

    '.movie-rating':
      observe: 'id'
      onGet: ->
        ratings =  @model.get('ratings')
        msg = 'No scores yet.'

        return msg if not ratings

        value = ratings['critics_score']

        return msg if value is -1
        return value + '%' unless value is -1

  events:
    'click .movie-title': ->
      console.log 'click'
      Radio.channel('main').command 'app:user:movie', @model.get('title')

  initialize:(options) ->
    return

  onRender: ->
    @stickit @model
    return

#--------------------------------------------------------------------------------
# Exports
#--------------------------------------------------------------------------------

module.exports = View

#--------------------------------------------------------------------------------