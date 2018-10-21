#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Radio      = require 'backbone.radio'
Marionette = require 'backbone.marionette'
AppRouter  = require 'marionette.approuter'
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
      signup: =>
        rootChannel.request('navigate', 'signup')
        @controller.signup()
        return

  controller:
    'signup': ->
      rootChannel.request('rootview').showChildView 'content', new View()
      return

  appRoutes:
    'signup/': 'signup'

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = Router

#-------------------------------------------------------------------------------
