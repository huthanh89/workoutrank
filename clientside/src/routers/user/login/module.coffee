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

  validation:
    email:
      required: true

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:
    form:   '#login-form'
    signup: '#tab-signup'

  bindings:
    '#login-email':    'email'
    '#login-password': 'password'

  modelEvents:
    'change sync': ->
      @ui.form.validator()
      return

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
      return

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')


  onRender: ->
    Backbone.Validation.bind @,
      model: @model
    @stickit()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.View  = View
module.exports.Model = Model

#-------------------------------------------------------------------------------
