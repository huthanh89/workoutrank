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
      profile: (isNew) =>
        rootChannel.request('navigate', 'profile')
        @controller.profile(isNew)
        return

  controller:
    profile: (isNew) ->
      navChannel.request('nav:main')
      rootChannel.request 'spin:page:loader', true
      
      async.waterfall [
        (callback) ->
          model = new Model.Model()
          model.fetch
            success: (model) -> callback null, model
            error: (model, error) -> callback error
        (userModel, callback) ->
          wLogs = new Model.WLogCollection()
          wLogs.fetch
            success: (wLogs) -> callback null, userModel, wLogs
            error: (model, error) -> callback error
          return

      ], (error, userModel, wLogs) =>
        if error
          rootChannel.request 'message:error', error
        else
          rootChannel.request 'spin:page:loader', false
          rootChannel.request('rootview').showChildView 'content', new View.default
            model: userModel
            wLogs: wLogs
            isNew: isNew
          return

      return

  appRoutes:
    'profile/': 'profile'

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = Router

#-------------------------------------------------------------------------------
