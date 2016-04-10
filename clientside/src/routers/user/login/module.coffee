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
require 'backbone.validation'

#-------------------------------------------------------------------------------
# Model
#-------------------------------------------------------------------------------

class Model extends Backbone.Model

  url:  'api/login'

  defaults:
    email:    ''
    password: ''

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:
    signup: '#index-tab-signup'

  bindings:
    '#index-login-email':    'email'
    '#index-login-password': 'password'

  events:
    'click @ui.signup': ->
      @rootChannel.request('index')
      return

    'submit': (event) ->
      event.preventDefault()

      @model.save {},
        success: (model) =>
          @rootChannel.request('home')
          return
        error: (model, response) =>
          @rootChannel.request 'message', 'danger', "Failed: #{response.responseText}"
          return

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')

  onRender: ->

    @model.set
      email: 'admin'
      password: '1234'

    @stickit()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.View  = View
module.exports.Model = Model

#-------------------------------------------------------------------------------
