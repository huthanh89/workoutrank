#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_        = require 'lodash'
async    = require 'async'
mongoose = require 'mongoose'

#-------------------------------------------------------------------------------
# Models
#-------------------------------------------------------------------------------

Strength = mongoose.model('strength')
SLog     = mongoose.model('slog')

#-------------------------------------------------------------------------------
# GET
#
#   Get count of all exercises and all logs.
#-------------------------------------------------------------------------------

module.get = (req, res, next) ->

  async.waterfall [

    (callback) ->

      Strength.count
        user: req.session.user._id
      .exec (err, count) ->
        return callback err if err
        return callback null, count
      return

    (strengthCount, callback) ->

      # Get logs

      SLog.count
        user: req.session.user._id
      .exec (err, count) ->
        return callback err if err
        return callback null, strengthCount, count

      return

  ], (err, exerciseCount, logCount) ->

    console.log 'ERROR', err if err

    return res.json
      exerciseCount: exerciseCount
      logCount:      logCount

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = module

#-------------------------------------------------------------------------------