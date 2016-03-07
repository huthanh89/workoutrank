#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

async    = require 'async'
mongoose = require 'mongoose'

#-------------------------------------------------------------------------------
# Models
#-------------------------------------------------------------------------------

Strength = mongoose.model('strength')

#-------------------------------------------------------------------------------
# List
#-------------------------------------------------------------------------------

module.list = (req, res, next) ->

  async.waterfall [

    (callback) ->
      Strength.find()
      .exec (err, documents) ->
        console.log 'ERROR', err if err
        callback null, documents
      return
  ], (err, documents) ->

    console.log 'ERROR', err if err

    return res.json documents

#-------------------------------------------------------------------------------
# Get
#-------------------------------------------------------------------------------

module.get = (req, res, next) ->

  async.waterfall [

    (callback) ->

      console.log req.params

      Strength.findOne
        _id: req.params.sid
      .exec (err, document) ->
        console.log 'ERROR', err if err
        callback null, document
      return

  ], (err, document) ->

    console.log 'ERROR', err if err

    return res.json document

#-------------------------------------------------------------------------------
# Post
#-------------------------------------------------------------------------------

module.post = (req, res) ->

  async.waterfall [

    (callback) ->

      Strength.create
        date:    req.body.date
        name:    req.body.name
        muscle:  req.body.muscle
        note:    req.body.note
        session: req.body.session
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
# Exports
#-------------------------------------------------------------------------------

module.exports = module

#-------------------------------------------------------------------------------