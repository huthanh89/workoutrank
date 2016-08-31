#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Backbone     = require 'backbone'
Marionette   = require 'marionette'
Feedback     = require './feedback/module'
LandingView  = require './landing/view'
SignupView   = require './signup/view'
LoginView    = require './login/view'
AboutView    = require './about/view'

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
        @rootChannel.request 'navigate', ''
        @index()
        return

      'signup': =>
        @rootChannel.request 'navigate', 'signup'
        @signup()
        return

      'login': =>
        @rootChannel.request 'navigate', 'login'
        @login()
        return

      'logout': =>
        @rootChannel.request 'spin:page:loader', true
        model = new Backbone.Model()

        model.save {},
          url: '/api/logout'
          success: =>
            @rootChannel.request 'spin:page:loader', false
            @navigate('login', trigger: true)
            @login()
            return
          error: (model, error) =>
            @rootChannel.request 'message:error', error
            return
        return

      'about': =>
        @rootChannel.request 'navigate', 'about'
        @about()
        return

      'feedback': =>
        @rootChannel.request 'navigate', 'feedback'
        @feedback()
        return

  # Routes used for backbone urls.
  # Handle routes with APIs at the bottom.
  # Do not append "(/)" this will cause the view to load twice.
  # Appending "/" will suffice.

  routes:
    '':         'index'
    'signup':   'signup'
    'login':    'login'
    'about':    'about'
    'feedback': 'feedback'

  # Api for Route handling.
  # Update Navbar and show view.

  index: ->
    @navChannel.request('nav:index')
    @rootView.content.empty()
    @rootView.index.show new LandingView()
    return

  signup: ->
    @navChannel.request('nav:index')
    @rootView.index.empty()
    @rootView.content.show new SignupView()
    return

  login: ->
    @navChannel.request('nav:index')
    @rootView.index.empty()
    @rootView.content.show new LoginView()
    return

  about: ->
    @navChannel.request('nav:index')
    @rootView.index.empty()
    @rootView.content.show new AboutView()
    return

  feedback: ->
    @navChannel.request('nav:index')
    @rootView.index.empty()
    @rootView.content.show new Feedback.View
      model: new Feedback.Model()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = Router

#-------------------------------------------------------------------------------
