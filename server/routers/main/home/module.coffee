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
Schedule = mongoose.model('schedule')

#-------------------------------------------------------------------------------
# GET
#
#   Get count of all exercises and all logs.
#-------------------------------------------------------------------------------

module.get = (req, res) ->

  result =
    sConfs:    0
    sLogs:     0
    schedules: 0

  async.waterfall [

    (callback) ->
      Strength
      .count
        user: req.session.passport.user
      .lean()
      .exec (err, count) ->
        return callback err.message if err
        result.sConfs = count
        return callback null
      return

    (callback) ->
      SLog
      .count
        user: req.session.passport.user
      .lean()
      .exec (err, count) ->
        return callback err.message if err
        result.sLogs = count
        return callback null
      return

    (callback) ->
      Schedule
      .findOne
        user: req.session.passport.user
      .lean()
      .exec (err, schedule) ->
        return callback err.message if err
        if schedule?
          result.schedules += schedule.sunday.length
          result.schedules += schedule.monday.length
          result.schedules += schedule.tuesday.length
          result.schedules += schedule.wednesday.length
          result.schedules += schedule.thursday.length
          result.schedules += schedule.friday.length
          result.schedules += schedule.saturday.length
        return callback null
      return

  ], (err) ->

    # If Error occurred, return error status and text.

    if err
      res
      .status 400
      .json   err

    else

      res
      .status 200
      .json result

    return
#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = module

#-------------------------------------------------------------------------------