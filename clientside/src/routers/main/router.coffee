#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

async      = require 'async'
Backbone   = require 'backbone'
Marionette = require 'marionette'
Home       = require './home/module'
Calendar   = require './calendar/module'
Schedule   = require './schedule/module'
Strength   = require './strength/module'
Cardio     = require './cardio/module'
Logs       = require './logs/module'
Weight     = require './weight/module'
Timeline   = require './timeline/module'

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
        @rootChannel.request 'navigate', 'home'
        @home()
        return

      'strengths': (muscle) =>
        @rootChannel.request 'navigate', 'strengths'
        @strengths(muscle)
        return

      'strength:detail': (exerciseID) =>
        @rootChannel.request 'navigate', "strength/#{exerciseID}"
        @strengthDetail(exerciseID)
        return

      'cardios': =>
        @rootChannel.request 'navigate', 'cardios'
        @cardios()
        return

      'cardio:detail': (exerciseID) =>
        @rootChannel.request 'navigate', "cardio/#{exerciseID}"
        @strengthDetail(exerciseID)
        return

      'calendar': =>
        @rootChannel.request 'navigate', 'calendar'
        @calendar()
        return

      'schedule': =>
        @rootChannel.request 'navigate', 'schedule'
        @schedule()
        return

      'logs': =>
        @rootChannel.request 'navigate', 'logs'
        @logs()
        return

      'log:detail': (exerciseID) =>
        @rootChannel.request 'navigate', "log/#{exerciseID}"
        @logDetail(exerciseID)
        return

      'weights': =>
        @rootChannel.request 'navigate', 'weights'
        @weights()
        return

      'timeline': =>
        @rootChannel.request 'navigate', 'timeline'
        @timeline()
        return

  # Routes used for backbone urls.
  # Handle routes with APIs at the bottom.
  # Do not append "(/)" this will cause the view to load twice.
  # Appending "/" will suffice.

  routes:
    'home':           'home'
    'strengths':      'strengths'
    'strength/:sid/': 'strengthDetail'
    'cardios':        'cardios'
    'cardio/:cid/':   'cardioDetail'
    'summary':        'summary'
    'calendar':       'calendar'
    'schedule':       'schedule'
    'weights':        'weights'
    'timeline':       'timeline'
    'logs':           'logs'
    'log/:lid/':      'logDetail'

  # Api for Route handling.
  # Update Navbar and show view.

  home: ->

    @navChannel.request('nav:main')

    rootChannel = @rootChannel
    rootChannel.request 'spin:page:loader', true

    async.waterfall [

      (callback) ->

        user = Backbone.Radio.channel('user').request('user')

        user.fetch
          success: ->
            return callback null
          error: (model, error) -> callback error

      (callback) ->

        model = new Home.Model()
        model.fetch
          success: (model) -> callback null, model
          error: (model, error) -> callback error

    ], (error, model) =>

      rootChannel.request 'spin:page:loader', false
      if error
        rootChannel.request 'message:error', error

      @rootView.content.show new Home.View
        model: model
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

  cardios: ->

    @navChannel.request('nav:main')
    @rootChannel.request 'spin:page:loader', true

    result = {}

    async.waterfall [

      (callback) ->

        cConfs = new Cardio.Master.CConfs()

        cConfs.fetch
          success: (collection) ->
            result.cConfs = collection
            return callback null
          error: (model, error) -> callback error

        return

      (callback) ->
        cLogs = new Cardio.Master.CLogs()
        cLogs.fetch
          success: (collection) ->
            result.cLogs = collection
            return callback null
          error: (model, error) -> callback error
        return

    ], (error) =>

      @rootChannel.request 'spin:page:loader', false
      if error
        @rootChannel.request 'message:error', error

      else

        collection = new Cardio.Master.Collection [],
          cConfs: result.cConfs.models
          cLogs:  result.cLogs.models
          parse:  true

        @rootView.content.show new Cardio.Master.View
          collection: collection

    return

  cardioDetail: (exerciseID) ->

    @navChannel.request('nav:main')
    @rootChannel.request 'spin:page:loader', true

    result = {}

    async.waterfall [

      (callback) ->

        cConf = new Cardio.Detail.Model
          _id: exerciseID

        cConf.fetch
          success: (model) ->
            result.cConf = model
            return callback null
          error: (model, error) -> callback error

        return

      (callback) ->

        cLogs = new Strength.Detail.Collection [],
          id: exerciseID

        cLogs.fetch
          success: (collection) ->
            result.cLogs = collection
            return callback null
          error: (model, error) -> callback error

        return

      (callback) ->
        wLogs = new Weight.Collection()
        wLogs.fetch
          success: (wLogs) ->
            result.wLogs = wLogs
            return callback null
          error: (model, error) -> callback error
        return

    ], (error) =>

      @rootChannel.request 'spin:page:loader', false

      if error
        @rootChannel.request 'message:error', error

      else

        View = Strength.Detail.View

        console.log result

        @rootView.content.show new View
          model:      result.sConf
          collection: result.sLogs
          wLogs:      result.wLogs

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

  timeline: ->

    @navChannel.request('nav:main')
    @rootChannel.request 'spin:page:loader', true

    result = {}

    async.waterfall [

      (callback) ->

        wLogs = new Weight.Collection()
        wLogs.fetch
          success: (collection) ->
            result.wLogs = collection
            callback null
            return
          error: (model, error) -> callback error
        return

      (callback) ->

        sConfs = new Strength.Master.Collection()
        sConfs.fetch
          success: (collection) ->
            result.sConfs = collection
            callback null
            return
          error: (model, error) -> callback error
        return

      (callback) ->

        sLogs = new Timeline.SLogCollection()
        sLogs.fetch
          success: (collection) ->
            result.sLogs = collection
            callback null
            return
          error: (model, error) -> callback error
        return

    ], (error) =>

      @rootChannel.request 'spin:page:loader', false

      if error
        @rootChannel.request 'message:error', error
      else
        @rootView.content.show new Timeline.View
          collection: new Timeline.Collection [],
            sConfs: result.sConfs
            sLogs:  result.sLogs
            wLogs:  result.wLogs
            parse:  true

      return
#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = Router

#-------------------------------------------------------------------------------
