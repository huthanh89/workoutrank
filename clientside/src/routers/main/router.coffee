#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_          = require 'lodash'
async      = require 'async'
Backbone   = require 'backbone'
Marionette = require 'marionette'
Home       = require './home/module'
Calendar   = require './calendar/module'
Schedule   = require './schedule/module'
Strength   = require './strength/module'
Logs       = require './logs/module'
Weight     = require './weight/module'
Body       = require './body/module'

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

      'strengths': (muscle) =>
        @navigate('strengths', trigger:true)
        @strengths(muscle)
        return

      'strength:detail': (exerciseID) =>
        @navigate("strength/#{exerciseID}", trigger: true)
        @strengthDetail(exerciseID)
        return

      'calendar': =>
        @navigate('calendar', trigger: true)
        @calendar()
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

      'weights': =>
        @navigate('weights', trigger: true)
        @weights()
        return

      'body': =>
        @navigate('body', trigger: true)
        @body()
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
    'schedule':       'schedule'
    'weights':        'weights'
    'body':           'body'
    'logs':           'logs'
    'log/:lid/':      'logDetail'

  # Api for Route handling.
  # Update Navbar and show view.

  home: ->
    @navChannel.request('nav:main')
    @rootChannel.request 'spin:page:loader', true
    model = new Home.Model()
    model.fetch
      success: (model) =>
        @rootChannel.request 'spin:page:loader', false
        @rootView.content.show new Home.View
          model: model
        return
      error: (model, response) =>
        @rootChannel.request 'message:error', response
        return
    return

  strengths: (muscle) ->

    @navChannel.request('nav:main')
    @rootChannel.request 'spin:page:loader', true
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

      @rootChannel.request 'spin:page:loader', false
      if error
        @rootChannel.request 'message:error', error

      else
        View = Strength.Master.View

        @rootView.content.show new View
          collection: sConfs
          sLogs:      sLogs
          muscle:     muscle

      return

  strengthDetail: (strengthID) ->

    @navChannel.request('nav:main')
    @rootChannel.request 'spin:page:loader', true
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

      (sConf, sLogs, callback) ->
        wLogs = new Weight.Collection()
        wLogs.fetch
          success: (wLogs) -> callback null, sConf, sLogs, wLogs
          error: (model, error) -> callback error
        return

    ], (error, sConf, sLogs, wLogs) =>

      @rootChannel.request 'spin:page:loader', false

      if error
        @rootChannel.request 'message:error', error

      else
        View = Strength.Detail.View

        @rootView.content.show new View
          model:      sConf
          collection: sLogs
          wLogs:      wLogs

      return

    return

  calendar: ->

    @navChannel.request('nav:main')
    @rootChannel.request 'spin:page:loader', true
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

      @rootChannel.request 'spin:page:loader', false

      if error
        @rootChannel.request 'message:error', error
      else
        @rootView.content.show new Calendar.View
          sLogs:  sLogs
          sConfs: sConfs

      return

  schedule: ->

    @navChannel.request('nav:main')
    @rootChannel.request 'spin:page:loader', true
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

      (sConfs, sLogs, callback) ->
        model = new Schedule.Model()
        model.fetch
          success: (model) ->
            return callback null, sConfs, sLogs, model
          error: (model, error) -> callback error
        return

    ], (error, sConfs, sLogs, model) =>

      @rootChannel.request 'spin:page:loader', false

      if error
        @rootChannel.request 'message:error', error
      else
        @rootView.content.show new Schedule.View
          sLogs:  sLogs
          sConfs: sConfs
          model:  model

      return

  logs: ->

    @navChannel.request('nav:main')
    @rootChannel.request 'spin:page:loader', true
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

      @rootChannel.request 'spin:page:loader', false

      if error
        @rootChannel.request 'message:error', error
      else
        View = Logs.Master.View

        @rootView.content.show new View
          collection: sLogs
          sConfs:     sConfs

      return

  logDetail: (exerciseID) ->

    @navChannel.request('nav:main')
    @rootChannel.request 'spin:page:loader', true
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

      @rootChannel.request 'spin:page:loader', false

      if error
        @rootChannel.request 'message:error', error
      else
        View = Logs.Detail.View

        @rootView.content.show new View
          collection: sLogs
          sConf:      sConfs.get(exerciseID)

      return

  weights: ->

    @navChannel.request('nav:main')
    @rootChannel.request 'spin:page:loader', true
    async.waterfall [

      (callback) ->
        wLogs = new Weight.Collection()
        wLogs.fetch
          success: (wLogs) -> callback null, wLogs
          error: (model, error) -> callback error
        return

    ], (error, wLogs) =>

      @rootChannel.request 'spin:page:loader', false

      if error
        @rootChannel.request 'message:error', error
      else
        View = Weight.View
        @rootView.content.show new View
          collection: wLogs

      return

  body: ->

    @navChannel.request('nav:main')
    @rootChannel.request 'spin:page:loader', true
    async.waterfall [

      (callback) ->
        wLogs = new Body.Collection()
        wLogs.fetch
          success: (wLogs) -> callback null, wLogs
          error: (model, error) -> callback error
        return

    ], (error, wLogs) =>

      @rootChannel.request 'spin:page:loader', false

      if error
        @rootChannel.request 'message:error', error
      else
        View = Body.View
        @rootView.content.show new View
          collection: wLogs

      return
#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = Router

#-------------------------------------------------------------------------------
