#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment   = require 'moment'
async    = require 'async'
mongoose = require 'mongoose'

#-------------------------------------------------------------------------------
# Models
#-------------------------------------------------------------------------------

Cardio = mongoose.model('cardio')
CLog   = mongoose.model('clog')

#-------------------------------------------------------------------------------
# List
#   Return all cardio exercises matching user id.
#-------------------------------------------------------------------------------

module.list = (req, res) ->

  async.waterfall [

    (callback) ->

      Cardio
      .find
        user: req.session.passport.user
      .sort(date: -1)
      .lean()
      .exec (err, cardios) ->
        return callback err.message if err
        return callback null, cardios
      return

  ], (err, cardios) ->

    # Response error status and text.

    if err
      res
      .status 400
      .json   err

    return res.json cardios

#-------------------------------------------------------------------------------
# Get
#   Get a specific cardio workout matching cardio ID.
#-------------------------------------------------------------------------------

module.get = (req, res) ->

  async.waterfall [

    (callback) ->

      Cardio.findOne
        _id: req.params.cid
      .exec (err, cardio) ->
        return callback err.message if err
        return callback null, cardio
      return

  ], (err, cardio) ->

    # Response error status and text.

    if err
      res
      .status 400
      .json   err

    return res.json cardio

#-------------------------------------------------------------------------------
# Post
#   Create a new cardio exercise.
#-------------------------------------------------------------------------------

module.post = (req, res) ->

  async.waterfall [

    (callback) ->

      Cardio.create
        date: moment()
        name: req.body.name
        note: req.body.note
        user: req.session.passport.user

      , (err, cardio) ->
        return callback err.message if err
        return callback null, cardio

  ], (err, cardio) ->

    # If Error occured, return error status and text.

    if err
      res
      .status 400
      .json   err

    # If success return a 201 status code and json.

    res
    .status 201
    .json cardio

    return

  return

#-------------------------------------------------------------------------------
# PUT
#   Edit a new cardio exercise.
#-------------------------------------------------------------------------------

module.put = (req, res) ->

  async.waterfall [

    (callback) ->

      Cardio.findById req.params.cid, (err, cardio) ->
        return callback err.message if err
        return callback null, cardio

      return

    (cardio, callback) ->

      cardio.date = req.body.date
      cardio.name = req.body.name
      cardio.note = req.body.note

      cardio.save (err, entry) ->
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
# Delete
#   Delete a sConf record.
#-------------------------------------------------------------------------------

module.delete = (req, res) ->

  async.waterfall [

    (callback) ->

      Cardio.findById req.params.sid, (err, cardio) ->
        return callback err.message if err
        return callback null, cardio
      return

    (cardio, callback) ->

      # Remove all associated clogs.

      CLog
      .remove
        exercise: cardio.id
      .exec (err) ->
        return callback err.message if err
        return callback null, cardio
      return

    (cardio, callback) ->

      # Remove the actual sconf entry.

      cardio.remove (err) ->
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