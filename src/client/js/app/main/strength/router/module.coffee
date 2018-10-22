#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

async      = require 'async'
Backbone   = require 'backbone'
Radio      = require 'backbone.radio'
Marionette = require 'backbone.marionette'
AppRouter  = require 'marionette.approuter'
Model      = require '../model/module'
View       = require '../view/module'

#-------------------------------------------------------------------------------
# Channels
#-------------------------------------------------------------------------------

navChannel  = Radio.channel('nav')
rootChannel = Radio.channel('root')
userChannel = Radio.channel('user')

#-------------------------------------------------------------------------------
# Router
#-------------------------------------------------------------------------------

class Router extends AppRouter.default
  
  constructor: (options) ->
    super(options)
    rootChannel.reply

      strengths: (muscle) =>
        rootChannel.request('navigate', 'strengths')
        @controller.strengths(muscle)
        return

      'strength:detail': (exerciseID) =>
        rootChannel.request('navigate', "strengths/#{exerciseID}")
        @controller.strengthDetail(exerciseID)
        return

  controller:

    strengths: (muscle) ->

      navChannel.request('nav:main')
      rootChannel.request 'spin:page:loader', true
      async.waterfall [

        (callback) ->

          SConfs = View.Master.Collection
          sconfs = new SConfs()

          sconfs.fetch
            success: (collection) -> callback null, collection
            error: (model, error) -> callback error

          return

        (sConfs, callback) ->
          sLogs = new Model.StrengthCollection()
          sLogs.fetch
            success: (collection) -> callback null, sConfs, collection
            error: (model, error) -> callback error
          return

      ], (error, sConfs, sLogs) =>

        rootChannel.request 'spin:page:loader', false
        if error
          rootChannel.request 'message:error', error

        else
          rootChannel.request('rootview').showChildView 'content', new View.Master.View
            collection: sConfs
            sLogs:      sLogs
            muscle:     muscle

        return
      return

    strengthDetail: (strengthID) ->

      navChannel.request('nav:main')
      rootChannel.request 'spin:page:loader', true
      async.waterfall [

        (callback) ->

          sConf = new View.Detail.Model
            _id: strengthID

          sConf.fetch
            success: (model) -> callback null, model
            error: (model, error) -> callback error

          return

        (sConf, callback) ->

          sLogs = new View.Detail.Collection [],
            id: strengthID

          sLogs.fetch
            success: (collection) -> callback null, sConf, collection
            error: (model, error) -> callback error

          return

        (sConf, sLogs, callback) ->
          wLogs = new Model.WeightCollection()
          wLogs.fetch
            success: (wLogs) -> callback null, sConf, sLogs, wLogs
            error: (model, error) -> callback error
          return

      ], (error, sConf, sLogs, wLogs) =>

        rootChannel.request 'spin:page:loader', false

        if error
          rootChannel.request 'message:error', error

        else

          rootChannel.request('rootview').showChildView 'content', new View.Detail.View
            model:      sConf
            collection: sLogs
            wLogs:      wLogs

        return

      return

  appRoutes:
    'strengths/':    'strengths'
    'strengths/:id': 'strengthDetail'

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = Router

#-------------------------------------------------------------------------------
