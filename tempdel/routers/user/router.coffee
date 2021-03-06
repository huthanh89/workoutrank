#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

async      = require 'async'
Radio      = require 'backbone.radio'
Marionette = require 'backbone.marionette'
AppRouter  = require 'marionette.approuter'
Account    = require './account/module'
Profile    = require './profile/module'
Weight     = require '../main/weight/module'

#-------------------------------------------------------------------------------
# Channels
#-------------------------------------------------------------------------------

navChannel  = Radio.channel('nav')
rootChannel = Radio.channel('root')

#-------------------------------------------------------------------------------
# Router
#-------------------------------------------------------------------------------

class Router extends AppRouter.default

  constructor: (options)->
    super(options)
    @rootView = rootChannel.request('rootview')

    # Replies for menu navigation.
    # Change the url path with @navigate('url path')
    # before being sent to route handler.
    # When changing url, set trigger true to trigger onRoute() call.

    rootChannel.reply

      'account': =>
        rootChannel.request 'navigate', 'account'
        @account()
        return

      'profile': (isNew) =>
        rootChannel.request 'navigate', 'profile'
        @profile(isNew)
        return

  # Routes used for backbone urls.
  # Handle routes with APIs at the bottom.
  # Do not append "(/)" this will cause the view to load twice.
  # Appending "/" will suffice.

  routes:
    'account': 'account'
    'profile': 'profile'

  # Api for Route handling.
  # Update Navbar and show view.

  account: ->
    navChannel.request('nav:main')
    model = new Account.Model()
    model.fetch
      success: (model) =>
        @rootView.showChildView 'content', new Account.View
          model: model
        return
      error: (model, response) ->
        rootChannel.request 'message', 'danger', "Error: #{response.responseText}"
        return
    return

  profile: (isNew) ->

    navChannel.request('nav:main')
    async.waterfall [
      (callback) ->
        model = new Profile.Model()
        model.fetch
          success: (model) -> callback null, model
          error: (model, error) -> callback error
      (userModel, callback) ->
        wLogs = new Weight.Collection()
        wLogs.fetch
          success: (wLogs) -> callback null, userModel, wLogs
          error: (model, error) -> callback error
        return

    ], (error, userModel, wLogs) =>
      if error
        rootChannel.request 'message:error', error
      else
        @rootView.showChildView 'content', new Profile.View
          model: userModel
          wLogs: wLogs
          isNew: isNew
        return
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = Router

#-------------------------------------------------------------------------------
