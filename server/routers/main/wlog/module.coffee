#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_        = require 'lodash'
async    = require 'async'
mongoose = require 'mongoose'

#-------------------------------------------------------------------------------
# Models
#-------------------------------------------------------------------------------

WLog = mongoose.model('wlog')

#-------------------------------------------------------------------------------
# List
#   Get all wlogs from this user.
#-------------------------------------------------------------------------------

module.list = (req, res) ->

  async.waterfall [

    (callback) ->

      WLog
      .find
        user: req.session.passport.user
      .lean()
      .exec (err, wlogs) ->
        return callback err.message if err
        return callback null, wlogs

      return

  ], (err, documents) ->

    if err
      res
      .status 400
      .json   err

    return res.json documents

#-------------------------------------------------------------------------------
# Get
#   Get a specific wlogs with matching strengthID
#-------------------------------------------------------------------------------

module.get = (req, res) ->

  async.waterfall [

    (callback) ->

      WLog
      .find
        exercise: req.params.sid
      .lean()
      .exec (err, wlogs) ->
        return callback err.message if err
        return callback null, wlogs
      return

  ], (err, documents) ->

    if err
      res
      .status 400
      .json   err

    return res.json documents

#-------------------------------------------------------------------------------
# Post
#   Create a new wlog. As well as updating the strength workout's last date.
#-------------------------------------------------------------------------------

module.post = (req, res) ->

  async.waterfall [

    (callback) ->

      # Create a new wlog entry.

      WLog.create
        date:     req.body.date
        note:     req.body.note
        weight:   req.body.weight
        user:     req.session.passport.user
      , (err, wlog) ->
        return callback err.message if err
        return callback null, wlog

  ], (err, wlog) ->

    if err
      res
      .status 400
      .json   err

    res
    .status 201
    .json wlog

    return

  return

#-------------------------------------------------------------------------------
# Put
#   Edit a wlog record.
#-------------------------------------------------------------------------------

module.put = (req, res) ->

  async.waterfall [

    (callback) ->

      WLog.findById req.params.sid, (err, wlog) ->
        return callback err.message if err
        return callback null, wlog

      return

    (wlog, callback) ->

      wlog.date    = req.body.date
      wlog.muscle  = req.body.muscle
      wlog.note    = req.body.note
      wlog.session = req.body.session

      wlog.save (err, wlog) ->
        return callback err.message if err
        return callback null, wlog

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
#   Delete a wlog record.
#-------------------------------------------------------------------------------

module.delete = (req, res) ->

  async.waterfall [

    (callback) ->

      WLog.findById req.params.sid, (err, wlog) ->
        return callback err.message if err
        return callback null, wlog
      return

    (wlog, callback) ->

      wlog.remove (err) ->
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