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
Strength = mongoose.model('strength')

#-------------------------------------------------------------------------------
# GET
#
#   Get a list all logs pertaining to a certain exercise.
#-------------------------------------------------------------------------------

module.get = (req, res, next) ->

  async.waterfall [

    (callback) ->

      Exercise.find()
      .lean()
      .exec (err, exercises) ->
        console.log 'ERROR', err if err
        return callback null, exercises[0].strength

      return

    (strengths, callback) ->

      # Find a certain exercise.

      strength = _.find strengths, (strength) ->
        return strength._id.toString() is req.params.sid

      return callback null, strength

    (strength, callback) ->

      # Get logs

      Strength.find
        exercise: req.params.sid
      .sort 'date'
      .lean()
      .exec (err, exercises) ->
        console.log 'ERROR', err if err
        return callback null, strength, exercises

      return

  ], (err, strength, exercises) ->

    console.log 'ERROR', err if err

    result = _.chain {}
      .extend strength
      .extend log: exercises
      .value()

    return res.json result

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = module

#-------------------------------------------------------------------------------