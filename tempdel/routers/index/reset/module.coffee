#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

swal         = require 'sweetalert'
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

rootChannel = Radio.channel('root')

#-------------------------------------------------------------------------------
# Model
#-------------------------------------------------------------------------------

class Model extends Backbone.Model

  url: 'api/reset'

  defaults:
    password: ''
    confirm:  ''
    user:     ''
    token:    ''

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.View

  template: viewTemplate

  bindings:
    '#reset-password': 'password'
    '#reset-confirm':  'confirm'

  events:
    'click #reset-home': ->
      rootChannel.request 'index'
      return

    'click #reset-forgot': ->
      rootChannel.request 'forgot'
      return

    'submit': (event) ->
      event.preventDefault()

      rootChannel.request 'spin:page:loader', true

      @model.save null,
        success: ->
          rootChannel.request 'spin:page:loader', false
          swal
            title: 'Success!'
            text:  'New password updated.'
            type:  'success'

          rootChannel.request 'login'
          return
        error: (model, response) ->
          rootChannel.request 'message:error', response
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
