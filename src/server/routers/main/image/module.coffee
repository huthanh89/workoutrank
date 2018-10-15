#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

async    = require 'async'
mongoose = require 'mongoose'

#-------------------------------------------------------------------------------
# Models
#-------------------------------------------------------------------------------

Image = mongoose.model('image')

#-------------------------------------------------------------------------------
# List
#   Get all images from this user.
#-------------------------------------------------------------------------------

module.list = (req, res) ->

  async.waterfall [

    (callback) ->

      Image
      .find
        user: req.session.passport.user
      .lean()
      .exec (err, images) ->
        return callback err.message if err
        return callback null, images

      return

  ], (err, documents) ->

    if err
      res
      .status 400
      .json   err

    return res.json documents

#-------------------------------------------------------------------------------
# Get
#   Get a specific images with matching strengthID
#-------------------------------------------------------------------------------

module.get = (req, res) ->

  async.waterfall [

    (callback) ->

      WLog
      .find
        exercise: req.params.sid
      .lean()
      .exec (err, images) ->
        return callback err.message if err
        return callback null, images
      return

  ], (err, documents) ->

    if err
      res
      .status 400
      .json   err

    return res.json documents

#-------------------------------------------------------------------------------
# Post
#   Create a new image. As well as updating the strength workout's last date.
#-------------------------------------------------------------------------------

module.post = (req, res) ->

  async.waterfall [

    (callback) ->

      # Create a new image entry.

      WLog.create
        date:     req.body.date
        note:     req.body.note
        weight:   req.body.weight
        user:     req.session.passport.user
      , (err, image) ->
        return callback err.message if err
        return callback null, image

  ], (err, image) ->

    if err
      res
      .status 400
      .json   err

    res
    .status 201
    .json image

    return

  return

#-------------------------------------------------------------------------------
# Put
#   Edit a image record.
#-------------------------------------------------------------------------------

module.put = (req, res) ->

  async.waterfall [

    (callback) ->

      WLog.findById req.params.sid, (err, image) ->
        return callback err.message if err
        return callback null, image

      return

    (image, callback) ->

      image.date    = req.body.date
      image.muscle  = req.body.muscle
      image.note    = req.body.note
      image.session = req.body.session

      image.save (err, image) ->
        return callback err.message if err
        return callback null, image

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
#   Delete a image record.
#-------------------------------------------------------------------------------

module.delete = (req, res) ->

  async.waterfall [

    (callback) ->

      WLog.findById req.params.sid, (err, image) ->
        return callback err.message if err
        return callback null, image
      return

    (image, callback) ->

      image.remove (err) ->
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