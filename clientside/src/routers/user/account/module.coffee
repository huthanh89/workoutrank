#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Backbone     = require 'backbone'
Marionette   = require 'marionette'
Summary      = require './summary/module'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'backbone.stickit'

#-------------------------------------------------------------------------------
# Model
#-------------------------------------------------------------------------------

class Model extends Backbone.Model

  idAttribute: '_id'

  urlRoot: '/api/account'

  defaults:
    firstname: ''
    lastname:  ''
    email:     ''

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  regions:
    summary: '#account-summary'

  bindings:
    '#account-firstname': 'firstname'
    '#account-lastname':  'lastname'
    '#account-email':     'email'
    '#account-password':  'password'

  events:

    'click #account-home': ->
      @rootChannel.request 'home'
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

  constructor: (options) ->
    super
    @rootChannel = Backbone.Radio.channel('root')

  onRender: ->
    @stickit()
    return

  onShow: ->
    @showChildView 'summary', new Summary.View
      model: @model

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

exports.Model = Model
exports.View  = View

#-------------------------------------------------------------------------------
