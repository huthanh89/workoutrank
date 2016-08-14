#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Backbone   = require 'backbone'
Marionette = require 'marionette'
Signup     = require './signup/module'
LoginView  = require './login/view'

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
    # When changing url, set trigger true to trigger onRoute() call.

    @rootChannel.reply

      'index': =>
        @navigate('')
        @login()
        return

      'signup': =>
        @navigate('signup')
        @login()
        return

      'login': =>
        @navigate('login')
        @login()
        return

      'logout': =>
        @rootChannel.request 'spin:page:loader', true
        model = new Backbone.Model()
        model.save {},
          url: 'api/logout'
          success: =>
            @rootChannel.request 'spin:page:loader', false
            @navigate('login', trigger: true)
            @login()
            return
          error: (model, error) =>
            @rootChannel.request 'message:error', error
            return

        return

  # Routes used for backbone urls.
  # Handle routes with APIs at the bottom.
  # Do not append "(/)" this will cause the view to load twice.
  # Appending "/" will suffice.

  routes:
    '':       'login'
    'signup': 'login'
    'login':  'login'

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
    @rootView.content.show new LoginView()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = Router

#-------------------------------------------------------------------------------
