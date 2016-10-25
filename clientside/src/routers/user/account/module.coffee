#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Backbone     = require 'backbone'
Marionette   = require 'marionette'
Local        = require './local/module'
Social       = require './social/module'
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

    'click #account-logout': ->
      @rootChannel.request('logout')
      return

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')

  onShow: ->

    if @model.get('provider') is 'local'
      @showChildView 'summary', new Local.View
        model: @model
    else
      @showChildView 'summary', new Social.View
        model: @model
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

exports.Model = Model
exports.View  = View

#-------------------------------------------------------------------------------
