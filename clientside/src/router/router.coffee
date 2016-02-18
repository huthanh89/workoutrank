#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_          = require 'lodash'
Backbone   = require 'backbone'
Marionette = require 'marionette'
Index      = require './views/index/module'
Signup     = require './views/signup/module'
Login      = require './views/login/module'
Home       = require './views/home/module'
Profile    = require './views/profile/module'

#-------------------------------------------------------------------------------
# Router
#-------------------------------------------------------------------------------

class Router extends Marionette.AppRouter

  constructor: ->

    super

    @navChannel  = Backbone.Radio.channel('nav')
    @rootChannel = Backbone.Radio.channel('root')
    @rootView    = @rootChannel.request('rootview')

    # Replies for menu navigation.
    # Change the url path with @navigate('url path')
    # before being sent to route handler.

    @rootChannel.reply

      index: =>
        @navigate('')
        @signup()
        return

      signup: =>
        @navigate('signup')
        @signup()
        return

      login: =>
        @navigate('login')
        @login()
        return

      home: =>
        @navigate('home')
        @home()
        return

      profile: =>
        @navigate('profile')
        @profile()
        return

  # Routes used for backbone urls.

  routes:
    '':        'signup'
    'signup':  'signup'
    'login':   'login'
    'home':    'home'
    'profile': 'profile'

  # Api for Route handling.
  # Update Navbar and show view.

  index: ->
    @navChannel.request('nav:index')
    console.log 'no index page, redirect to signup'
    return

  signup: ->
    @navChannel.request('nav:index')
    @rootView.content.show new Signup.View
      model: new Signup.Model()
    return

  login: ->
    @navChannel.request('nav:index')
    @rootView.content.show new Login.View
      model: new Login.Model()
    return

  home: ->
    @navChannel.request('nav:main')
    @rootView.content.show new Home.View()
    return

  profile: ->
    @navChannel.request('nav:main')
    collection = new Profile.Collection()

    collection.fetch
      success: (collection) ->
        console.log 'done', collection
        return
      error: ->
        console.log 'error'
        return

    @rootView.content.show(new Profile.View())
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = Router

#-------------------------------------------------------------------------------
