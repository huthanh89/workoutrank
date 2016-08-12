#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_          = require 'lodash'
async      = require 'async'
Backbone   = require 'backbone'
Marionette = require 'marionette'
Home       = require './home/module'
Calendar   = require './calendar/module'
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

      'strengths': =>
        @navigate('strengths', trigger: true)
        @strengths()
        return

      'strength:detail': (exerciseID) =>
        @navigate("strength/#{exerciseID}", trigger: true)
        @strengthDetail(exerciseID)
        return

      'calendar': =>
        @navigate('calendar', trigger: true)
        @calendar()
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
    'home':           'home'
    'strengths':      'strengths'
    'strength/:sid/': 'strengthDetail'
    'summary':        'summary'
    'calendar':       'calendar'
    'logs':           'logs'
    'log/:lid/':      'logDetail'
    'multiplayer':    'multiplayer'

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
        @rootChannel.request 'message:error', response
        return
    return

  strengths: ->

    @navChannel.request('nav:main')

    async.waterfall [

      (callback) ->

        SConfs = Strength.Master.Collection
        sconfs = new SConfs()

        sconfs.fetch
          success: (collection) -> callback null, collection
          error: (model, error) -> callback error

        return

      (sConfs, callback) ->
        sLogs = new Logs.Master.Collection()
        sLogs.fetch
          success: (collection) -> callback null, sConfs, collection
          error: (model, error) -> callback error
        return

    ], (error, sConfs, sLogs) =>

      if error
        @rootChannel.request 'message:error', error

      View = Strength.Master.View

      @rootView.content.show new View
        collection: sConfs
        sLogs:      sLogs

      return

  strengthDetail: (strengthID) ->

    @navChannel.request('nav:main')

    async.waterfall [

      (callback) ->

        sConf = new Strength.Detail.Model
          _id: strengthID

        sConf.fetch
          success: (model) -> callback null, model
          error: (model, error) -> callback error

        return

      (sConf, callback) ->

        sLogs = new Strength.Detail.Collection [],
          id: strengthID

        sLogs.fetch
          success: (collection) -> callback null, sConf, collection
          error: (model, error) -> callback error

        return

    ], (error, sConf, sLogs) =>

      if error
        @rootChannel.request 'message:error', error

      View = Strength.Detail.View

      @rootView.content.show new View
        model:      sConf
        collection: sLogs

      return

    return

  calendar: ->

    @navChannel.request('nav:main')
    async.waterfall [

      (callback) ->
        sConfs = new Strength.Master.Collection()
        sConfs.fetch
          success: (sConfs) -> callback null, sConfs
          error: (model, error) -> callback error

        return

      (sConfs, callback) ->

        sLogs  = new Logs.Master.Collection()
        sLogs.fetch
          success: (sLogs) -> callback null, sConfs, sLogs
          error: (collection, error) -> callback error

        return

    ], (error, sConfs, sLogs) =>

      if error
        @rootChannel.request 'message:error', error

      @rootView.content.show new Calendar.View
        sLogs:  sLogs
        sConfs: sConfs

      return

  logs: ->

    @navChannel.request('nav:main')
    async.waterfall [

      (callback) ->
        sConfs = new Strength.Master.Collection()
        sConfs.fetch
          success: (sConfs) -> callback null, sConfs
          error: (model, error) -> callback error

        return

      (sConfs, callback) ->

        sLogs  = new Logs.Master.Collection()
        sLogs.fetch
          success: (sLogs) -> callback null, sConfs, sLogs
          error: (collection, error) -> callback error

        return

    ], (error, sConfs, sLogs) =>

      if error
        @rootChannel.request 'message:error', error

      View = Logs.Master.View

      @rootView.content.show new View
        collection: sLogs
        sConfs:     sConfs

      return

  logDetail: (exerciseID) ->

    @navChannel.request('nav:main')
    async.waterfall [

      (callback) ->
        sConfs = new Strength.Master.Collection()
        sConfs.fetch
          success: (sConfs) -> callback null, sConfs
          error: (collection, error) -> callback error
        return

      (sConfs, callback) ->
        sLogs = new Logs.Detail.Collection [],
          _id: exerciseID
        sLogs.fetch
          success: (sLogs) -> callback null, sConfs, sLogs
          error: (model, error) -> callback error
        return

    ], (error, sConfs, sLogs) =>

      if error
        @rootChannel.request 'message:error', error

      View = Logs.Detail.View

      @rootView.content.show new View
        collection: sLogs
        sConf:      sConfs.get(exerciseID)

      return

  logDetail2: (exerciseID) ->
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
        @rootChannel.request 'message:error', response
        return

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = Router

#-------------------------------------------------------------------------------
