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
#   Get all slogs from this user.
#-------------------------------------------------------------------------------

module.list = (req, res, next) ->

  async.waterfall [

    (callback) ->

      SLog.find
        user: req.session.user.id
      .exec (err, slogs) ->
        console.log 'ERROR', err if err
        return callback null, slogs

      return

  ], (err, documents) ->

    console.log 'ERROR', err if err

    return res.json documents

#-------------------------------------------------------------------------------
# Get
#   Get a specific slogs with matching strengthID
#-------------------------------------------------------------------------------

module.get = (req, res, next) ->

  async.waterfall [

    (callback) ->

      SLog.find
        exercise: req.params.sid
      .exec (err, slogs) ->
        console.log 'ERROR', err if err
        return callback null, slogs
      return

  ], (err, documents) ->

    console.log 'ERROR', err if err

    return res.json documents

#-------------------------------------------------------------------------------
# Post
#   Create a new slog.
#-------------------------------------------------------------------------------

module.post = (req, res) ->

  async.waterfall [

    (callback) ->

      SLog.create
        date:     req.body.date
        name:     req.body.name
        muscle:   req.body.muscle
        exercise: req.body.exercise
        note:     req.body.note
        rep:      req.body.rep
        weight:   req.body.weight
        user:     req.session.user._id
      , (err, result) ->
        return callback err if err
        return callback null, result

  ], (err, result) ->

    console.log err if err

    res
    .status 201
    .json result

    return

  return

#-------------------------------------------------------------------------------
# Put
#   Edit a slog record.
#-------------------------------------------------------------------------------

module.put = (req, res, next) ->

  async.waterfall [

    (callback) ->

      SLog.findById req.params.sid, (err, strength) ->
        console.log 'ERROR', err if err
        return callback null, slog

      return

    (slog, callback) ->

      slog.date    = req.body.date
      slog.muscle  = req.body.muscle
      slog.name    = req.body.name
      slog.note    = req.body.note
      slog.session = req.body.session

      slog.save (err, slog) ->
        console.log 'ERROR', err if err
        return callback null, slog

      return

  ], (err, document) ->

    console.log 'ERROR', err if err

    # Return json if success.

    return res.json document

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = module

#-------------------------------------------------------------------------------