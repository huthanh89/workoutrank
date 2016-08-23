#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Backbone     = require 'backbone'
Marionette   = require 'marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'backbone.stickit'

#-------------------------------------------------------------------------------
# Model
#-------------------------------------------------------------------------------

class Model extends Backbone.Model

  url: 'api/feedback'

  defaults:
    type:  0
    title: ''
    text:  ''

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  bindings:
    '#feedback-text': 'text'

  events:
    'click #feedback-home': ->
      @rootChannel.request 'index'
      return

    'submit': (event) ->
      event.preventDefault()
      @rootChannel.request 'spin:page:loader', true

      @model.save null,
        success: (model) =>
          @rootChannel.request 'spin:page:loader', false
          @rootChannel.request 'show:'
          @rootChannel.request('home')
          return
        error: (model, response) =>
          @rootChannel.request 'message:error', response
          return

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')

  onRender: ->
    @stickit()
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
