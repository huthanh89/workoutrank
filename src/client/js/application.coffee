
#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

GA          = require './ga'
GCT         = require './gct'
Backbone    = require 'backbone'
Radio       = require 'backbone.radio'
Marionette  = require 'backbone.marionette'
#IndexRouter = require './routers/index/router'
#MainRouter  = require './routers/main/router'
#UserRouter  = require './routers/user/router'
#AdminRouter = require './routers/admin/router'
RootView    = require './view'

#-------------------------------------------------------------------------------
# Channels
#-------------------------------------------------------------------------------

rootChannel = Radio.channel('root')

#-------------------------------------------------------------------------------
# User
#-------------------------------------------------------------------------------

class User extends Backbone.Model

  url: '/api/user'

  defaults:
    firstname: ''
    lastname:  ''
    email:     ''
    height:    0
    gender:    0
    auth:      1

#-------------------------------------------------------------------------------
# Create Application.
#-------------------------------------------------------------------------------

class Application extends Marionette.Application

  region: 'body'

  # Send route url to google analytics.
  # Send conversion data for specific routes.

  trackAnalytics: (route) ->

    rootChannel.request 'clear:navigation', route

    if route in [
      'login'
      'signup'
      'index'
      'about'
      'feedback'
    ]
      $('#navigator').hide()
    else
      $('#navigator').show()

    @googleAnalytics.send(route)
    if route is 'signup'
      @googleTrackingConversion.send()
    return

  onStart: ->

    # Start Google analytics

    @googleAnalytics = new GA()

    # Start Google adword conversion tracker.

    @googleTrackingConversion = new GCT()

    rootChannel.reply

      'get:route': => @route

      # Workaround for the refresh and navigate which will called twice.
      # Trigger set to false so method will not get called twice.

      navigate: (route) =>
        Backbone.history.navigate route, trigger:false
        @trackAnalytics route
        return

    # Show Root view.

    @showView new RootView
      user: new User()

    ###
    # All router must be initialized before backbone.history starts to work.

    new IndexRouter
      mode:          'auto'
      trailingSlash: 'ignore'

    new MainRouter
      mode:          'auto'
      trailingSlash: 'ignore'

    new UserRouter
      mode:          'auto'
      trailingSlash: 'ignore'

    new AdminRouter
      mode:          'auto'
      trailingSlash: 'ignore'
    ###

    # Called when url is changed during navigation.

    Backbone.history.on 'route', (router, route) =>
      @trackAnalytics route
      return

    # Start backbone history a main step to bookmark-able url's.

    Backbone.history.start
      pushState:  true
      hashChange: false

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = Application

#-------------------------------------------------------------------------------
