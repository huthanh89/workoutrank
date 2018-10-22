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
      weights: =>
        rootChannel.request('navigate', 'weights')
        @controller.weights()
        return

  controller:
    weights: ->
      navChannel.request('nav:main')
      rootChannel.request 'spin:page:loader', true
      async.waterfall [

        (callback) ->
          wLogs = new Model.Collection()
          wLogs.fetch
            success: (wLogs) -> callback null, wLogs
            error: (model, error) -> callback error
          return

      ], (error, wLogs) =>

        rootChannel.request 'spin:page:loader', false

        if error
          rootChannel.request 'message:error', error
        else
          rootChannel.request('rootview').showChildView 'content', new View.default
            collection: wLogs
        return

      return

  appRoutes:
    'weights/': 'weights'

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = Router

#-------------------------------------------------------------------------------
