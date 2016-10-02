#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_        = require 'lodash'
moment   = require 'moment'
async    = require 'async'
mongoose = require 'mongoose'

#-------------------------------------------------------------------------------
# Models
#-------------------------------------------------------------------------------

User = mongoose.model('user')

#-------------------------------------------------------------------------------
# GET
#-------------------------------------------------------------------------------

module.get = (req, res, next) ->

  async.waterfall [

    (callback) ->

      User.find()
      .exec (err, users) ->
        return callback err if err

        result = []

        _.each users, (user) ->
          result.push user.getPublicFields()
          return

        return callback null, result
      return

  ], (err, users) ->

    if err
      res
      .status 400
      .json   err

    res.json users

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = module

#-------------------------------------------------------------------------------