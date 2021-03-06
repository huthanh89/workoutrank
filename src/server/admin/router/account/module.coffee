#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_        = require 'lodash'
moment   = require 'moment'
async    = require 'async'
mongoose = require 'mongoose'

#-------------------------------------------------------------------------------
# Models
#-------------------------------------------------------------------------------

User     = mongoose.model('user')
CLog     = mongoose.model('clog')
Cardio   = mongoose.model('cardio')
SLog     = mongoose.model('slog')
Strength = mongoose.model('strength')
WLog     = mongoose.model('wlog')

#-------------------------------------------------------------------------------
# GET
#-------------------------------------------------------------------------------

module.get = (req, res) ->

  result =
    users:  []
    cLogs:  []
    cConfs: []
    sLogs:  []
    sConfs: []
    wLogs:  []

  async.waterfall [

    (callback) ->

      User.find()
      .exec (err, users) ->
        return callback err if err
        _.each users, (user) ->
          result.users.push user.getPublicFields()
          return
        return callback null
      return

    (callback) ->

      CLog.find()
      .exec (err, cLogs) ->
        return callback err if err
        result.cLogs = cLogs
        return callback null
      return

    (callback) ->

      SLog.find()
      .exec (err, sLogs) ->
        return callback err if err
        result.sLogs = sLogs
        return callback null
      return

    (callback) ->

      Cardio.find()
      .exec (err, cConfs) ->
        return callback err if err
        result.cConfs = cConfs
        return callback null
      return

    (callback) ->

      Strength.find()
      .exec (err, sConfs) ->
        return callback err if err
        result.sConfs = sConfs
        return callback null
      return

    (callback) ->

      WLog.find()
      .exec (err, wLogs) ->
        return callback err if err
        result.wLogs = wLogs
        return callback null
      return

  ], (err) ->

    if err
      res
      .status 400
      .json   err

    res.json result

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = module

#-------------------------------------------------------------------------------