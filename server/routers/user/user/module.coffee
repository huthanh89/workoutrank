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

exports.get = (req, res) ->

  async.waterfall [

    (callback) ->

      User
      .findById req.session.user._id
      .exec (err, user) ->
        return callback err if err
        return callback null, user.getPublicFields()
      return

  ], (err, user) ->

    if err
      res
      .status 400
      .json   err

    return res.json user

#-------------------------------------------------------------------------------