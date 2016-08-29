#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

$            = require 'jquery'
swal         = require 'sweetalert'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
Summary      = require './summary/module'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'backbone.stickit'
require 'touchspin'

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
    weight:    null

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  regions:
    summary: '#account-summary'

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
          swal('Success', 'Profile Updated!', 'success')
          return
        error: (model, response) =>
          @rootChannel.request 'message:error', response
          return

  constructor: (options) ->
    super
    @rootChannel = Backbone.Radio.channel('root')

  onShow: ->
    @showChildView 'summary', new Summary.View
      model: @model
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

exports.Model = Model
exports.View  = View

#-------------------------------------------------------------------------------
