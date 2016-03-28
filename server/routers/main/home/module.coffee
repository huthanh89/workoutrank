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
#   Get a list all logs.
#-------------------------------------------------------------------------------

module.get = (req, res, next) ->

  async.waterfall [

    (callback) ->

      Exercise.findOne
        user: req.session.user._id
      .exec (err, exercise) ->
        console.log 'ERROR', err if err
        callback null,  exercise.strength.length
      return

    (exerciseCount, callback) ->

      # Get logs

      Strength.count
        user: req.session.user._id
      .exec (err, count) ->
        console.log 'ERROR', err if err
        return callback null, exerciseCount, count

      return

  ], (err, exerciseCount, logCount) ->

    console.log 'ERROR', err if err

    return res.json
      exerciseCount: exerciseCount
      logCount:      logCount

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = module

#-------------------------------------------------------------------------------