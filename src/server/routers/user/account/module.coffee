#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment    = require 'moment'
async     = require 'async'
mongoose  = require 'mongoose'
validator = require 'validator'

#-------------------------------------------------------------------------------
# Models
#-------------------------------------------------------------------------------

User  = mongoose.model('user')
WLog  = mongoose.model('wlog')
Image = mongoose.model('image')

#-------------------------------------------------------------------------------
# GET
#-------------------------------------------------------------------------------

module.get = (req, res) ->

  result = {}

  async.waterfall [

    (callback) ->

      id = req.session.passport.user

      return callback 'No Session ID' if id is undefined

      User
      .findOne
        _id: id
      .exec (err, user) ->
        return callback 'No user found' if user is null
        return callback err if err

        result = user.getPublicFields()

        return callback null
      return

  ], (err) ->

    if err
      res
      .status 400
      .json   err

    else
      res
      .status 200
      .json result

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = module

#-------------------------------------------------------------------------------