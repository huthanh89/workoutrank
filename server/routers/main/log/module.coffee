#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

async    = require 'async'
mongoose = require 'mongoose'

#-------------------------------------------------------------------------------
# Models
#-------------------------------------------------------------------------------

SLog     = mongoose.model('slog')

#-------------------------------------------------------------------------------
# GET XXX Not yet implemented
#
#   Get a list of all logs combine.
#-------------------------------------------------------------------------------

module.get = (req, res) ->

  async.waterfall [

    (callback) ->

      # Get logs

      SLog
      .find
        user: req.session.passport.user
      .sort 'date'
      .lean()
      .exec (err, slogs) ->
        return callback err.message if err
        return callback null, slogs

      return

  ], (err, slogs) ->

    # If Error occured, return error status and text.

    if err
      res
      .status 400
      .json   err
    return res.json slogs

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = module

#-------------------------------------------------------------------------------