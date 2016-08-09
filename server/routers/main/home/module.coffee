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
        return callback err.message if err
        return callback null, count
      return

    (strengthCount, callback) ->

      # Get logs

      SLog.count
        user: req.session.user._id
      .exec (err, count) ->
        return callback err.message if err
        return callback null, strengthCount, count

      return

  ], (err, exerciseCount, logCount) ->

    # If Error occured, return error status and text.

    if err
      res
      .status 400
      .json   err

    return res
    .status 200
    .json
      exerciseCount: exerciseCount
      logCount:      logCount

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = module

#-------------------------------------------------------------------------------