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
      home: =>
        rootChannel.request('navigate', 'home')
        @controller.home()
        return

  controller:
    home: ->
      navChannel.request('nav:main')
      rootChannel.request 'spin:page:loader', true
      
      async.waterfall [

        (callback) ->

          user = userChannel.request('user')

          user.fetch
            success: ->
              return callback null
            error: (model, error) -> callback error

        (callback) ->

          model = new Model.default()
          model.fetch
            success: (model) -> callback null, model
            error: (model, error) -> callback error

      ], (error, model) =>

        rootChannel.request 'spin:page:loader', false
        if error
          rootChannel.request 'message:error', error

        rootChannel.request('rootview').showChildView 'content', new View
          model: model 
        return

      return

  appRoutes:
    'home/': 'home'

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = Router

#-------------------------------------------------------------------------------
