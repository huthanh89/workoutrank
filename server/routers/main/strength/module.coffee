#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_        = require 'lodash'
async    = require 'async'
mongoose = require 'mongoose'
Err      = require '../../error'
Validate = require '../../validate'

#-------------------------------------------------------------------------------
# Models
#-------------------------------------------------------------------------------

Strength = mongoose.model('strength')
SLog     = mongoose.model('slog')

#-------------------------------------------------------------------------------
# Schema for POST and PUT validation
#-------------------------------------------------------------------------------

schema =
  date: [
    method: 'isDate'
  ]
  name: [
    method: 'isLength'
    options:
      min: 1
      max: 25
  ]
  note: [
    method: 'isLength'
    options:
      min: 0
      max: 50
  ]
  count: [
    method: 'isInt'
  ]
  body: [
    method: 'isBoolean'
  ]

#-------------------------------------------------------------------------------
# List
#   Return all strength exercises matching user id.
#-------------------------------------------------------------------------------

module.list = (req, res, next) ->

  async.waterfall [

    (callback) ->

      Strength.find
        user: req.session.passport.user
      .sort(date: -1)
      .lean()
      .exec (err, strengths) ->
        return callback err.message if err
        return callback null, strengths
      return

  ], (err, strengths) ->

    # Response error status and text.

    if err
      res
      .status 400
      .json   err

    return res.json strengths

#-------------------------------------------------------------------------------
# Get
#   Get a specific strength workout matching strength ID.
#-------------------------------------------------------------------------------

module.get = (req, res, next) ->

  async.waterfall [

    (callback) ->

      Strength.findOne
        _id: req.params.sid
      .exec (err, strength) ->
        return callback err.message if err
        return callback null, strength
      return

  ], (err, strength) ->

    # Response error status and text.

    if err
      res
      .status 400
      .json   err

    return res.json strength

#-------------------------------------------------------------------------------
# Post
#   Create a new strength exercise.
#-------------------------------------------------------------------------------

module.post = (req, res) ->

  async.waterfall [

    (callback) ->

      return Validate.isValid(req.body, schema, callback)

    (callback) ->

      error = null
      error = 'Select which muscle will be targeted' if req.body.muscle.length is 0

      return callback error if error
      return callback null

    (callback) ->

      Strength.create
        date:   req.body.date
        name:   req.body.name
        note:   req.body.note
        muscle: req.body.muscle
        body:   req.body.body
        user:   req.session.passport.user

      , (err, strength) ->
        return callback err.message if err
        return callback null, strength

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

module.put = (req, res, next) ->

  async.waterfall [

    (callback) ->

      return Validate.isValid(req.body, schema, callback)

    (callback) ->

      Strength.findById req.params.sid, (err, strength) ->
        return callback err.message if err
        return callback null, strength

      return

    (strength, callback) ->

      strength.date   = req.body.date
      strength.name   = req.body.name
      strength.note   = req.body.note
      strength.muscle = req.body.muscle
      strength.body   = req.body.body

      strength.save (err, entry) ->
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
# Log
#
#   Get a list all slogs matching that strength exercise id.
#-------------------------------------------------------------------------------

module.log = (req, res, next) ->

  async.waterfall [

    (callback) ->
      SLog.find
        exercise: req.params.sid
      .sort(date: -1)
      .lean()
      .exec (err, slogs) ->
        return callback err.message if err
        return callback null, slogs
      return

  ], (err, slogs) ->

    if err
      res
      .status 400
      .json   err

    return res.json slogs

#-------------------------------------------------------------------------------
# Delete
#   Delete a slog record.
#-------------------------------------------------------------------------------

module.delete = (req, res, next) ->

  async.waterfall [

    (callback) ->
      Strength.findById req.params.sid, (err, strength) ->
        return callback err.message if err
        return callback null, strength
      return

    (strength, callback) ->

      # Remove all associated logs.

      SLog.remove
        exercise: strength.id
      .exec (err, slogs) ->
        return callback err.message if err
        return callback null, strength
      return

    (strength, callback) ->

      # Remove actual sconf entry.

      strength.remove (err) ->
        return callback err.message if err
        return callback null
      return


  ], (err) ->

    if err
      res
      .status 400
      .json   err

    res.sendStatus 204

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = module

#-------------------------------------------------------------------------------