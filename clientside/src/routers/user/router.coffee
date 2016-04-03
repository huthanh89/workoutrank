#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_          = require 'lodash'
async      = require 'async'
Backbone   = require 'backbone'
Marionette = require 'marionette'
Signup     = require './signup/module'
Login      = require './login/module'
Profile    = require './profile/module'

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
    # When changing url, set trigger true to trigger onRoute()

    @rootChannel.reply

      'index': =>
        @navigate('')
        @signup()
        return

      'signup': =>
        @navigate('signup', trigger: true)
        @signup()
        return

      'login': =>
        @navigate('login', trigger: true)
        @login()
        return

      'logout': =>
        @navigate('')
        @signup()
        return

      'profile': =>
        @navigate('profile', trigger: true)
        @profile()
        return

  # Routes used for backbone urls.
  # Handle routes with APIs at the bottom.
  # Do not append "(/)" this will cause the view to load twice.
  # Appending "/" will suffice.

  routes:
    '':                  'signup'
    '/':                 'signup'
    'signup':            'signup'
    'login':             'login'
    'profile':           'profile'

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

  profile: ->
    @navChannel.request('nav:main')

    model = new Profile.Model()

    model.fetch
      success: (model) =>
        @rootView.content.show new Profile.View
          model: model
        return
      error: (model, response) =>
        @rootChannel.request 'message', 'danger', "Error: #{response.responseText}"
        return

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = Router

#-------------------------------------------------------------------------------
