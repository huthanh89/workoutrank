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
SLog     = mongoose.model('slog')

#-------------------------------------------------------------------------------
# GET XXX Not yet implemented
#
#   Get a list of all logs combine.
#-------------------------------------------------------------------------------

module.get = (req, res, next) ->

  async.waterfall [

    (callback) ->

      # Get logs

      SLog.find
        user: req.session.user._id
      .sort 'date'
      .lean()
      .exec (err, slogs) ->
        return callback err if err
        return callback null, slogs

      return

  ], (err, slogs) ->

    console.log 'ERROR', err if err

    return res.json slogs

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = module

#-------------------------------------------------------------------------------