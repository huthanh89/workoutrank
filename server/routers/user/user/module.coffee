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

      userID = req.session.passport.user

      return callback 'No Session ID' if userID is undefined

      User
      .findOne
        $or: [
          _id: userID
        ,
          facebookID: userID
        ]
      .exec (err, user) ->
        return callback 'No user found' if user is null
        return callback err if err
        return callback null, user.getPublicFields()
      return

  ], (err, user) ->

    if err

      res
      .status 400
      .json   err

    else

      res
      .status 200
      .json user

    return

#-------------------------------------------------------------------------------