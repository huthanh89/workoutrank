#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Backbone     = require 'backbone'
Radio        = require 'backbone.radio'
Marionette   = require 'backbone.marionette'
Local        = require './local/module'
Social       = require './social/module'
viewTemplate = require './view.pug'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'backbone.stickit'
require 'touchspin'

#-------------------------------------------------------------------------------
# Channels
#-------------------------------------------------------------------------------

rootChannel = Radio.channel('root')

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

class View extends Marionette.View

  template: viewTemplate

  regions:
    summary: '#account-summary'

  events:

    'click #account-home': ->
      rootChannel.request 'home'
      return

    'click #account-logout': ->
      rootChannel.request('logout')
      return

  onAttach: ->

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
