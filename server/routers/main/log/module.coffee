#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_        = require 'lodash'
async    = require 'async'
mongoose = require 'mongoose'

#-------------------------------------------------------------------------------
# Models
#-------------------------------------------------------------------------------

Strength = mongoose.model('strength')

#-------------------------------------------------------------------------------
# GET
#
#   Get a list all logs.
#-------------------------------------------------------------------------------

module.get = (req, res, next) ->

  async.waterfall [

    (callback) ->

      # Get logs

      Strength.find
        user: req.session.user._id
      .sort 'date'
      .lean()
      .exec (err, exercises) ->
        console.log 'ERROR', err if err
        return callback null, exercises

      return

  ], (err, exercises) ->

    console.log 'ERROR', err if err

    return res.json exercises

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = module

#-------------------------------------------------------------------------------