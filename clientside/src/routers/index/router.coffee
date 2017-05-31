#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Backbone     = require 'backbone'
Radio        = require 'backbone.radio'
Marionette   = require 'backbone.marionette'
Feedback     = require './feedback/module'
Forgot       = require './forgot/module'
Reset        = require './reset/module'
LandingView  = require './landing/view'
SignupView   = require './signup/view'
LoginView    = require './login/view'
AboutView    = require './about/view'

#-------------------------------------------------------------------------------
# Channels
#-------------------------------------------------------------------------------

rootChannel = Radio.channel('root')
navChannel  = Radio.channel('nav')

#-------------------------------------------------------------------------------
# Router
#-------------------------------------------------------------------------------

class Router extends Marionette.AppRouter

  constructor: ->

    super

    @rootView = rootChannel.request('rootview')

    # Replies for menu navigation.
    # Change the url path with @navigate('url path')
    # before being sent to route handler.
    # When changing url, set trigger true to trigger onRoute() call.

    rootChannel.reply

      'index': =>
        rootChannel.request 'navigate', ''
        @index()
        return

      'signup': =>
        rootChannel.request 'navigate', 'signup'
        @signup()
        return

      'login': =>
        rootChannel.request 'navigate', 'login'
        @login()
        return

      'logout': =>
        rootChannel.request 'spin:page:loader', true
        model = new Backbone.Model()

        model.save {},
          url: '/api/logout'
          success: =>
            rootChannel.request 'spin:page:loader', false
            @navigate('login', trigger: true)
            @login()
            return
          error: (model, error) ->
            rootChannel.request 'message:error', error
            return
        return

      'about': =>
        rootChannel.request 'navigate', 'about'
        @about()
        return

      'feedback': =>
        rootChannel.request 'navigate', 'feedback'
        @feedback()
        return

      'forgot': =>
        rootChannel.request 'navigate', 'forgot'
        @forgot()
        return

      'reset': =>
        rootChannel.request 'navigate', 'reset'
        @reset()
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
    'forgot':   'forgot'
    'reset':    'reset'

  # Api for Route handling.
  # Update Navbar and show view.

  index: ->
    navChannel.request('nav:index')
    @rootView.showChildView 'index', new LandingView()
    return

  signup: ->
    navChannel.request('nav:basic')
    @rootView.showChildView 'index', new SignupView()
    return

  login: ->
    navChannel.request('nav:basic')
    @rootView.showChildView 'index', new LoginView()
    return

  about: ->
    navChannel.request('nav:basic')
    @rootView.showChildView 'index', new AboutView()
    return

  feedback: ->
    navChannel.request('nav:basic')
    @rootView.showChildView 'index', new Feedback.View
      model: new Feedback.Model()
    return

  forgot: ->
    navChannel.request('nav:basic')
    @rootView.showChildView 'index', new Forgot.View
      model: new Forgot.Model()
    return

  reset: (query) ->

    ###
    XXX workaround:
    TODO: parse query the right way instead of using the following function.
###

    QueryStringToJSON = ->
      pairs = location.search.slice(1).split('&')
      result = {}
      pairs.forEach (pair) ->
        pair = pair.split('=')
        result[pair[0]] = decodeURIComponent(pair[1] or '')
        return
      JSON.parse JSON.stringify(result)

    query = QueryStringToJSON()

    navChannel.request('nav:index')

    @rootView.showChildView 'index', new Reset.View
      model: new Reset.Model
        user:  query.user
        token: query.token
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = Router

#-------------------------------------------------------------------------------
