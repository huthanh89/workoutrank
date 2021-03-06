#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_         = require 'lodash'
async     = require 'async'
moment    = require 'moment'
mongoose  = require 'mongoose'
crypto    = require 'crypto'
Validate  = require '../../validate'

#-------------------------------------------------------------------------------
# Models
#-------------------------------------------------------------------------------

User = mongoose.model('user')

#-------------------------------------------------------------------------------
# Sanitize given string
#-------------------------------------------------------------------------------

sanitize = (string) -> string.trim().toLowerCase().replace(' ', '')

#-------------------------------------------------------------------------------
# Post
#-------------------------------------------------------------------------------

schema =
  user: [
    method: 'isLength'
    options:
      min: 2
      max: 25
  ]
  password: [
    method: 'isLength'
    options:
      min: 1
      max: 20
  ]

exports.post = (req, res) ->

  async.waterfall [

    (callback) ->
      return Validate.isValid(req.body, schema, callback)

    (callback) ->

      user = sanitize(req.body.user)

      User
      .findOne
        $or: [
          username: user
        , email: user
        ]

      .exec (err, user) ->
        return callback err if err

        if user is null
          return callback 'Username / Email could not be found.'

        return callback null, user

      return

    (user, callback) ->

      password  = req.body.password
      salt      = user.salt
      algorithm = user.algorithm

      crypto.pbkdf2 password, salt, user.rounds, 32, algorithm, (err, key) ->
        if err
          return callback 'Could not look up username / password.'
        if user.key is key.toString('hex')
          return callback null, user.getPublicFields()
        else
          return callback 'Invalid username or password.'

      return

    (user, callback) ->

      if user isnt null

        # If login was successful then
        # Save user data to their session.

        req.session.user = user

        # Update lastlogin time.

        User.findOneAndUpdate
          _id: user._id
        ,
          lastlogin: moment()
        , (err, user) ->
          return callback err.message if err
          return callback null, user

      else

        req.session.user = null
        return callback null

  ], (err, user) ->

    # Response error status and text.

    if err
      res
      .status 400
      .json   err

    else
      res
      .status 201
      .json user

  return


#-------------------------------------------------------------------------------