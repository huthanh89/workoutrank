#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_        = require 'lodash'
moment   = require 'moment'
async    = require 'async'
mongoose = require 'mongoose'
Err      = require '../../error'
Validate = require '../../validate'

#-------------------------------------------------------------------------------
# Models
#-------------------------------------------------------------------------------

Schedule = mongoose.model('schedule')

#-------------------------------------------------------------------------------
# Schema for POST and PUT validation
#-------------------------------------------------------------------------------

schema =
  sunday:    []
  monday:    []
  tuesday:   []
  wednesday: []
  thursday:  []
  friday:    []
  saturday:  []

#-------------------------------------------------------------------------------
# Get
#-------------------------------------------------------------------------------

module.get = (req, res) ->

  async.waterfall [

    (callback) ->

      Schedule
      .findOne
        user: req.session.passport.user
      .lean()
      .exec (err, schedule) ->
        return callback err.message if err
        return callback null, schedule
      return

  ], (err, schedule) ->

    # Response error status and text.

    if err
      res
      .status 400
      .json   err

    return res.json schedule

#-------------------------------------------------------------------------------
# Post
#   Create a new strength exercise.
#-------------------------------------------------------------------------------

module.post = (req, res) ->

  async.waterfall [

    (callback) ->

      return Validate.isValid(req.body, schema, callback)

    (callback) ->

      Schedule.create
        user:      req.session.passport.user
        date:      moment()
        sunday:    req.body.sunday
        monday:    req.body.monday
        tuesday:   req.body.tuesday
        wednesday: req.body.wednesday
        thursday:  req.body.thursday
        friday:    req.body.friday
        saturday:  req.body.saturday

      , (err, schedule) ->
        return callback err.message if err
        return callback null, schedule

  ], (err, strength) ->

    # If Error occured, return error status and text.

    if err
      res
      .status 400
      .json   err

    # If success return a 201 status code and json.

    res
    .status 201
    .json strength

    return

  return

#-------------------------------------------------------------------------------
# PUT
#   Edit a new strength exercise.
#-------------------------------------------------------------------------------

module.put = (req, res) ->

  async.waterfall [

    (callback) ->

      return Validate.isValid(req.body, schema, callback)

    (callback) ->

      Schedule.findById req.params.sid, (err, schedule) ->
        return callback err.message if err
        return callback null, schedule

      return

    (schedule, callback) ->

      schedule.date      = moment()
      schedule.sunday    = req.body.sunday
      schedule.monday    = req.body.monday
      schedule.tuesday   = req.body.tuesday
      schedule.wednesday = req.body.wednesday
      schedule.thursday  = req.body.thursday
      schedule.friday    = req.body.friday
      schedule.saturday  = req.body.saturday

      schedule.save (err, entry) ->
        return callback err.message if err
        return callback null, entry

      return

  ], (err, entry) ->

    if err
      res
      .status 400
      .json   err

    # Return json if success.

    return res.json entry

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = module

#-------------------------------------------------------------------------------