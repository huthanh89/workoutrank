#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

async      = require 'async'
Backbone   = require 'backbone'
Radio      = require 'backbone.radio'
Marionette = require 'backbone.marionette'
AppRouter  = require 'marionette.approuter'
Model      = require '../model/module'
View       = require '../view/module'

#-------------------------------------------------------------------------------
# Channels
#-------------------------------------------------------------------------------

navChannel  = Radio.channel('nav')
rootChannel = Radio.channel('root')
userChannel = Radio.channel('user')

#-------------------------------------------------------------------------------
# Router
#-------------------------------------------------------------------------------

class Router extends AppRouter.default
  
  constructor: (options) ->
    super(options)
    rootChannel.reply
      account: =>
        rootChannel.request('navigate', 'account')
        @controller.account()
        return

  controller:
    account: ->
      navChannel.request('nav:main')
      model = new Model.default()
      model.fetch
        success: (model) =>
          rootChannel.request('rootview').showChildView 'content', new View.default
            model: model
          return
        error: (model, response) ->
          rootChannel.request 'message', 'danger', "Error: #{response.responseText}"
          return
      return

  appRoutes:
    'account/': 'account'

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = Router

#-------------------------------------------------------------------------------
