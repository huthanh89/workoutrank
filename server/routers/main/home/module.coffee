#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

async    = require 'async'
mongoose = require 'mongoose'

#-------------------------------------------------------------------------------
# Models
#-------------------------------------------------------------------------------

Strength = mongoose.model('strength')
SLog     = mongoose.model('slog')
WLog     = mongoose.model('wlog')
Schedule = mongoose.model('schedule')
Feedback = mongoose.model('feedback')
User     = mongoose.model('user')
Image    = mongoose.model('image')

#-------------------------------------------------------------------------------
# GET
#
#   Get count of all exercises and all logs.
#-------------------------------------------------------------------------------

module.get = (req, res) ->

  result =
    sConfs:        0
    sLogs:         0
    wLogs:         0
    users:         0
    feedbacks:     0
    profilePic:    0
    imageCount:    0
    scheduleCount: 0

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
      WLog
      .count
        user: req.session.passport.user
      .lean()
      .exec (err, count) ->
        return callback err.message if err
        result.wLogs = count
        return callback null
      return

    (callback) ->
      Feedback
      .count()
      .lean()
      .exec (err, count) ->
        return callback err.message if err
        result.feedbacks = count
        return callback null
      return

    (callback) ->
      User
      .count()
      .lean()
      .exec (err, count) ->
        return callback err.message if err
        result.users = count
        return callback null
      return

    (callback) ->
      Image
      .count()
      .lean()
      .exec (err, count) ->
        return callback err.message if err
        result.imageCount = count
        return callback null
      return

    (callback) ->
      Schedule
      .count()
      .lean()
      .exec (err, count) ->
        return callback err.message if err
        result.scheduleCount = count
        return callback null
      return

    (callback) ->

      Image
      .findOne
        user: req.session.passport.user
        imageType: 'profile'
      .lean()
      .exec (err, image) ->
        return callback err.message if err
        result.profilePic = image
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