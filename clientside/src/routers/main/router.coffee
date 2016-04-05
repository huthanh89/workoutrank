#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_          = require 'lodash'
async      = require 'async'
Backbone   = require 'backbone'
Marionette = require 'marionette'
Home       = require './home/module'
Summary    = require './summary/module'
Exercise   = require './exercise/module'
Strength   = require './strength/module'
Logs       = require './logs/module'

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

      'home': =>
        @navigate('home', trigger: true)
        @home()
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

      'strength:detail': (exerciseID) =>
        @navigate("strength/#{exerciseID}", trigger: true)
        @strengthDetail(exerciseID)
        return

      'strength:log': (exerciseID) =>
        @navigate("strength/#{exerciseID}/log", trigger: true)
        @strengthLog(exerciseID)
        return

      'summary': =>
        @navigate('summary', trigger: true)
        @summary()
        return

      'schedule': =>
        @navigate('schedule', trigger: true)
        @schedule()
        return

      'logs': =>
        @navigate('logs', trigger: true)
        @logs()
        return

      'log:detail': (exerciseID) =>
        @navigate("log/#{exerciseID}", trigger: true)
        @logDetail(exerciseID)
        return

      'multiplayer': =>
        @navigate('multiplayer', trigger: true)
        @multiplayer()
        return

  # Routes used for backbone urls.
  # Handle routes with APIs at the bottom.
  # Do not append "(/)" this will cause the view to load twice.
  # Appending "/" will suffice.

  routes:
    'home':              'home'
    'exercise':          'exercise'
    'strength/':         'strength'
    'strength/:sid/':    'strengthDetail'
    'strength/:sid/log': 'strengthLog'
    'summary':           'summary'
    'schedule':          'schedule'
    'logs':              'logs'
    'log/:lid/':         'logDetail'
    'multiplayer':       'multiplayer'

  # Api for Route handling.
  # Update Navbar and show view.

  home: ->
    @navChannel.request('nav:main')

    model = new Home.Model()

    model.fetch
      success: (model) =>
        @rootView.content.show new Home.View
          model: model
        return
      error: (model, response) =>
        @rootChannel.request 'message', 'danger', "Error: #{response.responseText}"
        return
    return

  strength: ->

    @navChannel.request('nav:main')

    Collection = Strength.Master.Collection
    View       = Strength.Master.View

    collection = new Collection()

    collection.fetch
      success: (collection) =>
        @rootView.content.show new View
          collection: collection
        return
      error: (model, response) =>
        @rootChannel.request 'message', 'danger', "Error: #{response.responseText}"
        return
    return

  strengthDetail: (strengthID) ->

    @navChannel.request('nav:main')

    View       = Strength.Detail.View
    Model      = Strength.Detail.Model
    Collection = Strength.Detail.Collection

    async.waterfall [

      (callback) ->

        strength = new Model
          _id: strengthID

        strength.fetch
          success: (strength) -> callback null, strength
          error: (model, error) -> callback err

        return

      (strength, callback) ->

        logs = new Collection [],
          id: strengthID

        logs.fetch
          success: (collection) -> callback null, strength, collection
          error: (model, error) -> callback error

        return

    ], (error, strength, collection) =>

      if error
        @rootChannel.request 'message', 'danger', "Error: #{error.responseText}"

      @rootView.content.show new View
        model:      strength
        collection: collection
        strengthID: strengthID

      return

    return

  strengthLog: (strengthID) ->

    @navChannel.request('nav:main')

    View  = Strength.Logs.View
    Model = Strength.Logs.Model

    model = new Model {},
      id: strengthID

    model.fetch
      success: (model) =>
        @rootView.content.show new View
          model:      model
          strengthID: strengthID
        return
      error: (model, response) =>
        @rootChannel.request 'message', 'danger', "Error: #{response.responseText}"
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
      error: (model, response) =>
        @rootChannel.request 'message', 'danger', "Error: #{response.responseText}"
        return
    return

  summary: ->
    @navChannel.request('nav:main')

    collection = new Summary.Collection()

    collection.fetch
      success: (collection) =>
        @rootView.content.show new Summary.View
          collection: collection
        return
      error: (model, response) =>
        @rootChannel.request 'message', 'danger', "Error: #{response.responseText}"
        return

    return

  schedule: ->
    @navChannel.request('nav:main')
    @rootView.content.show new Profile.View()
    return

  logs: ->
    @navChannel.request('nav:main')

    collection = new Strength.Master.Collection()

    View = Logs.Master.View

    collection.fetch
      success: (collection) =>
        @rootView.content.show new View
          collection: collection
        return
      error: (model, response) =>
        @rootChannel.request 'message', 'danger', "Error: #{response.responseText}"
        return
    return

  logDetail: (exerciseID) ->
    @navChannel.request('nav:main')

    collection = new Logs.Detail.Collection [],
      _id: exerciseID

     collection.fetch
      success: (collection) =>
        @rootView.content.show new Logs.Detail.View
          collection: collection
          model:      new Logs.Detail.Model()
        return
      error: (model, response) =>
        @rootChannel.request 'message', 'danger', "Error: #{response.responseText}"
        return

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
