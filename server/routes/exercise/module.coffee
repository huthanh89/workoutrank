#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

async    = require 'async'
mongoose = require 'mongoose'

#-------------------------------------------------------------------------------
# Models
#-------------------------------------------------------------------------------

Exercise = mongoose.model('exercise')

#-------------------------------------------------------------------------------
# GET
#-------------------------------------------------------------------------------

module.get = (req, res, next) ->

  async.waterfall [

    (callback) ->
      Exercise
      .find()
      .sort
        date: 1
      .exec (err, documents) ->
        console.log 'ERROR', err if err
        callback null, documents
      return
  ], (err, documents) ->

    console.log 'ERROR', err if err

    return res.json documents

#-------------------------------------------------------------------------------
# Post
#-------------------------------------------------------------------------------

module.post = (req, res) ->

  async.waterfall [

    (callback) ->

      Exercise.create
        date: new Date()
        name: req.body.name
        type: req.body.type
        note: req.body.note
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