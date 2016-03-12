#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_        = require 'lodash'
async    = require 'async'
mongoose = require 'mongoose'

#-------------------------------------------------------------------------------
# Models
#-------------------------------------------------------------------------------

Exercise = mongoose.model('exercise')

#-------------------------------------------------------------------------------
# Get
#   Return exercise model, which matches uid
#-------------------------------------------------------------------------------

module.get = (req, res, next) ->

  async.waterfall [

    (callback) ->

      Exercise.find()
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

      Exercise.find()
      .exec (err, exercise) ->
        console.log 'ERROR', err if err
        callback null, exercise[0]
      return

    (exercise, callback) ->

      exercise.strength.push {
            date:   new Date()
            name:   req.body.name
            note:   req.body.note
            muscle: req.body.muscle
          }

      exercise.save (err, result) ->
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