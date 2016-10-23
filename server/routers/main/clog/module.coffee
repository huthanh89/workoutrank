#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

async    = require 'async'
mongoose = require 'mongoose'

#-------------------------------------------------------------------------------
# Models
#-------------------------------------------------------------------------------

CLog = mongoose.model('clog')

#-------------------------------------------------------------------------------
# List
#   Get all clogs from this user.
#-------------------------------------------------------------------------------

module.list = (req, res) ->

  async.waterfall [

    (callback) ->

      CLog
      .find
        user: req.session.passport.user
      .lean()
      .exec (err, clogs) ->
        return callback err.message if err
        return callback null, clogs

      return

  ], (err, documents) ->

    if err
      res
      .status 400
      .json   err

    return res.json documents

#-------------------------------------------------------------------------------
# Get
#   Get a specific clogs with matching strengthID
#-------------------------------------------------------------------------------

module.get = (req, res) ->

  async.waterfall [

    (callback) ->

      WLog
      .find
        exercise: req.params.sid
      .lean()
      .exec (err, clogs) ->
        return callback err.message if err
        return callback null, clogs
      return

  ], (err, documents) ->

    if err
      res
      .status 400
      .json   err

    return res.json documents

#-------------------------------------------------------------------------------
# Post
#   Create a new clog. As well as updating the strength workout's last date.
#-------------------------------------------------------------------------------

module.post = (req, res) ->

  async.waterfall [

    (callback) ->

      # Create a new clog entry.

      WLog.create
        date:     req.body.date
        note:     req.body.note
        weight:   req.body.weight
        user:     req.session.passport.user
      , (err, clog) ->
        return callback err.message if err
        return callback null, clog

  ], (err, clog) ->

    if err
      res
      .status 400
      .json   err

    res
    .status 201
    .json clog

    return

  return

#-------------------------------------------------------------------------------
# Put
#   Edit a clog record.
#-------------------------------------------------------------------------------

module.put = (req, res) ->

  async.waterfall [

    (callback) ->

      WLog.findById req.params.sid, (err, clog) ->
        return callback err.message if err
        return callback null, clog

      return

    (clog, callback) ->

      clog.date    = req.body.date
      clog.muscle  = req.body.muscle
      clog.note    = req.body.note
      clog.session = req.body.session

      clog.save (err, clog) ->
        return callback err.message if err
        return callback null, clog

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
#   Delete a clog record.
#-------------------------------------------------------------------------------

module.delete = (req, res) ->

  async.waterfall [

    (callback) ->

      WLog.findById req.params.sid, (err, clog) ->
        return callback err.message if err
        return callback null, clog
      return

    (clog, callback) ->

      clog.remove (err) ->
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