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
# Get
#   Return all strength exercises matching user id.
#-------------------------------------------------------------------------------

module.get = (req, res, next) ->

  async.waterfall [

    (callback) ->

      Strength.find
        user: req.session.user._id
      .exec (err, strengths) ->
        console.log 'ERROR', err if err
        callback null, strengths
      return

  ], (err, strengths) ->

    console.log 'ERROR', err if err

    return res.json strengths1

#-------------------------------------------------------------------------------
# Post
#   Create a new strength exercise.
#-------------------------------------------------------------------------------

module.post = (req, res) ->

  async.waterfall [

    (callback) ->

      Strength.create
        date:   new Date()
        name:   req.body.name
        note:   req.body.note
        muscle: req.body.muscle

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
# Log
#
#   Get a list all slogs matching that strength exercise id.
#-------------------------------------------------------------------------------

module.log = (req, res, next) ->

  async.waterfall [

    (callback) ->

      SLog.find
        exercise: req.params.sid
      .lean()
      .exec (err, slogs) ->
        console.log 'ERROR', err if err
        return callback null, slogs
      return

  ], (err, slogs) ->

    console.log 'ERROR', err if err

    return res.json slogs

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = module

#-------------------------------------------------------------------------------