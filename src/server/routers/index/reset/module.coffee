#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_        = require 'lodash'
moment   = require 'moment'
async    = require 'async'
mongoose = require 'mongoose'
crypto   = require 'crypto'

#-------------------------------------------------------------------------------
# Models
#-------------------------------------------------------------------------------

User  = mongoose.model('user')
Token = mongoose.model('token')

#-------------------------------------------------------------------------------
# Sanitize given string
#-------------------------------------------------------------------------------

sanitize = (string) -> string.trim().toLowerCase().replace(' ', '')

#-------------------------------------------------------------------------------
# Post
#-------------------------------------------------------------------------------

exports.post = (req, res) ->

  async.waterfall [

    (callback) ->
      if req.body.password isnt req.body.confirm
        return callback 'Confirm passwords does not match.'
      else
        return callback null

    (callback) ->

      Token.findOne
        user:  req.body.user
        token: req.body.token

      .exec (err, token) ->
        return callback err if err

        if token is null
          return callback 'Password reset session expired. Go back to step 1 and start over.'
        else
          return callback null, token

    (token, callback) ->

      password = req.body.password
      salt     = crypto.randomBytes(32).toString('hex')

      crypto.pbkdf2 password, salt, 10000, 32, 'sha512', (err, key) ->
        return callback 'Could not process new password.' if err
        return callback null, token, salt, key.toString('hex')

      return

    (token, salt, key, callback) ->

      User.findOne
        $or: [
          username: req.body.user
        , email: req.body.user
        ]

      .exec (err, user) ->
        return callback err if err

        if user is null
          return callback 'Username / Email could not be found.'

        user.salt = salt
        user.key  = key

        return callback null, token, salt, key, user

      return

    (token, salt, key, user, callback) ->

      user.key  = key
      user.salt = salt

      user.save (err, user) ->
        return callback err.message if err
        return callback null, token

    (token, callback) ->

      token.remove (err) ->
        return callback err.message if err
        return callback null
      return

  ], (err) ->

    # Response error status and text.

    if err
      res
      .status 400
      .json   err

    else

      res
      .status 201
      .json req.body

  return

#-------------------------------------------------------------------------------

