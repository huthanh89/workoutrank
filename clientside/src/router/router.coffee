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
Exercise   = require './views/exercise/module'
Strength   = require './views/strength/module'

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

      'home': =>
        @navigate('home', trigger: true)
        @home()
        return

      'profile': =>
        @navigate('profile', trigger: true)
        @profile()
        return

      'exercise': =>
        @navigate('exercise', trigger: true)
        @exercise()
        return

      'exercise:detail': (type) =>
        @rootChannel.request "#{type}"
        return

      'strength': =>
        @navigate('strength', trigger: true)
        @strength()
        return

      'stat': =>
        @navigate('stat', trigger: true)
        @stat()
        return

      'schedule': =>
        @navigate('schedule', trigger: true)
        @schedule()
        return

      'log': =>
        @navigate('log', trigger: true)
        @log()
        return

      'multiplayer': =>
        @navigate('multiplayer', trigger: true)
        @multiplayer()
        return

  # Routes used for backbone urls.
  # Handle routes with APIs at the bottom.

  routes:
    '':                  'signup'
    '/':                 'signup'
    'signup':            'signup'
    'login':             'login'
    'home':              'home'
    'profile':           'profile'
    'exercise/':         'exercise'
    'strength':          'strength'
    'stat':              'stat'
    'schedule':          'schdeule'
    'log':               'log'
    'multiplayer':       'multiplayer'

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
    @rootView.content.show new Profile.View()
    return

  strength: ->
    @navChannel.request('nav:main')
    collection = new Strength.Collection()
    model      = new Strength.Model()
    view       = Strength.MasterView

    collection.fetch
      success: (collection) =>
        @rootView.content.show new view
          collection: collection
          model: model
        return
      error: ->
        console.log 'error'
        return
    return

  exercise: ->
    @navChannel.request('nav:main')
    collection = new Exercise.Master.Collection()
    model = new Exercise.Master.Model()

    collection.fetch
      success: (collection) =>
        @rootView.content.show new Exercise.Master.View
          collection: collection
          model: model
        return
      error: ->
        console.log 'error'
        return
    return

  exerciseDetail: (type) ->
    @navChannel.request('nav:main')
    View       = Exercise.Detail(type).View
    Model      = Exercise.Detail(type).Model
    Collection = Exercise.Detail(type).Collection

    collection = new Collection()

    collection.fetch
      success: (collection) =>
        @rootView.content.show new View
          collection: collection
          model:      new Model()
        return
      error: ->
        console.log 'error'
        return

    return

  stat: ->
    @navChannel.request('nav:main')
    @rootView.content.show new Profile.View()
    return

  schedule: ->
    @navChannel.request('nav:main')
    @rootView.content.show new Profile.View()
    return

  log: ->
    @navChannel.request('nav:main')
    @rootView.content.show new Profile.View()
    return

  multiplayer: ->
    @navChannel.request('nav:main')
    @rootView.content.show new Profile.View()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = Router

#-------------------------------------------------------------------------------
