#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

swal         = require 'sweetalert'
Backbone     = require 'backbone'
Radio        = require 'backbone.radio'
Marionette   = require 'backbone.marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'backbone.stickit'

#-------------------------------------------------------------------------------
# Channels
#-------------------------------------------------------------------------------

rootChannel = Radio.channel('root')

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

class View extends Marionette.View

  template: viewTemplate

  bindings:
    '#feedback-title':  'title'
    '#feedback-editor': 'text'

  modelEvents:
    sync: (model) ->
      model.clear().set(model.defaults)
      return

  events:
    'click #feedback-home': ->
      rootChannel.request 'home'
      return

    'submit': (event) ->
      event.preventDefault()

      @rootChannel.request 'spin:page:loader', true

      @model.save null,
        success: ->
          rootChannel.request 'spin:page:loader', false
          swal
            title: 'Success'
            text:  'Message Sent!'
            type:  'success'
          return
        error: (model, response) =>
          @rootChannel.request 'message:error', response
          return
      return

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
