#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_        = require 'lodash'
async    = require 'async'
mongoose = require 'mongoose'

#-------------------------------------------------------------------------------
# Models
#-------------------------------------------------------------------------------

SLog     = mongoose.model('slog')
Strength = mongoose.model('strength')

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
        return callback err.message if err
        return callback null, slogs

      return

  ], (err, documents) ->

    if err
      res
      .status 400
      .json   err

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
        return callback err.message if err
        return callback null, slogs
      return

  ], (err, documents) ->

    if err
      res
      .status 400
      .json   err

    return res.json documents

#-------------------------------------------------------------------------------
# Post
#   Create a new slog. As well as updating the strength workout's last date.
#-------------------------------------------------------------------------------

module.post = (req, res) ->

  async.waterfall [

    (callback) ->

      # Find the specific strength exercise.

      Strength.findById req.body.exercise, (err, strength) ->
        return callback err.message if err
        return callback null, strength
      return

    (strength, callback) ->

      # Update that strength's last date.

      strength.date = req.body.date

      strength.save (err) ->
        return callback err.message if err
        return callback null
      return

    (callback) ->

      # Create a new slog entry.

      SLog.create
        date:     req.body.date
        name:     req.body.name
        muscle:   req.body.muscle
        exercise: req.body.exercise
        note:     req.body.note
        rep:      req.body.rep
        weight:   req.body.weight
        user:     req.session.user._id
      , (err, slog) ->
        return callback err.message if err
        return callback null, slog

  ], (err, slog) ->

    if err
      res
      .status 400
      .json   err

    res
    .status 201
    .json slog

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
        return callback err.message if err
        return callback null, slog

      return

    (slog, callback) ->

      slog.date    = req.body.date
      slog.muscle  = req.body.muscle
      slog.name    = req.body.name
      slog.note    = req.body.note
      slog.session = req.body.session

      slog.save (err, slog) ->
        return callback err.message if err
        return callback null, slog

      return

  ], (err, document) ->

    if err
      res
      .status 400
      .json   err

    # Return json if success.

    return res.json document

#-------------------------------------------------------------------------------
# Delete
#   Delete a slog record.
#-------------------------------------------------------------------------------

module.delete = (req, res, next) ->

  async.waterfall [

    (callback) ->

      SLog.findById req.params.sid, (err, slog) ->
        return callback err.message if err
        return callback null, slog
      return

    (slog, callback) ->

      slog.remove (err) ->
        return callback err.message if err
        return callback null

      return

  ], (err) ->

    if err
      res
      .status 202
      .json   err

    res.sendStatus 204

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = module

#-------------------------------------------------------------------------------