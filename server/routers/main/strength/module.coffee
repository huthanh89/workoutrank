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
# List
#   Return all strength exercises matching user id.
#-------------------------------------------------------------------------------

module.list = (req, res, next) ->

  async.waterfall [

    (callback) ->

      Strength.find
        user: req.session.user._id
      .sort(date: -1)
      .lean()
      .exec (err, strengths) ->
        return callback err if err
        return callback null, strengths
      return

  ], (err, strengths) ->

    console.log 'ERROR', err if err

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
        return callback err if err
        return callback null, strength
      return

  ], (err, strength) ->

    console.log 'ERROR', err if err

    return res.json strength

#-------------------------------------------------------------------------------
# Post
#   Create a new strength exercise.
#-------------------------------------------------------------------------------

module.post = (req, res) ->

  async.waterfall [

    (callback) ->

      Strength.create
        date:   req.body.date
        name:   req.body.name
        note:   req.body.note
        muscle: req.body.muscle
        body:   req.body.body
        user:   req.session.user._id

      , (err, strength) ->
        return callback err if err
        return callback null, strength

  ], (err, strength) ->

    console.log err if err

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

      Strength.findById req.params.sid, (err, strength) ->
        return callback err if err
        return callback null, strength

      return

    (strength, callback) ->

      strength.date   = req.body.date
      strength.name   = req.body.name
      strength.note   = req.body.note
      strength.muscle = req.body.muscle
      strength.body   = req.body.body

      strength.save (err, entry) ->
        return callback err if err
        return callback null, entry

      return

  ], (err, entry) ->

    console.log 'ERROR', err if err

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
        return callback err if err
        return callback null, slogs
      return

  ], (err, slogs) ->

    console.log 'ERROR', err if err

    return res.json slogs

#-------------------------------------------------------------------------------
# Delete
#   Delete a slog record.
#-------------------------------------------------------------------------------

module.delete = (req, res, next) ->

  async.waterfall [

    (callback) ->

      Strength.findById req.params.sid, (err, strength) ->
        console.log 'ERROR', err if err
        return callback null, strength
      return

    (strength, callback) ->

      strength.remove (err) ->
        return callback err if err
        return callback null

      return

  ], (err) ->

    console.log 'ERROR', err if err

    res.sendStatus 204

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = module

#-------------------------------------------------------------------------------