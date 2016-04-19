#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Validate  = require '../../validate'
Err       = require '../../error'
moment    = require 'moment'
async     = require 'async'
mongoose  = require 'mongoose'
crypto    = require 'crypto'

#-------------------------------------------------------------------------------
# Models
#-------------------------------------------------------------------------------

User = mongoose.model('user')

#-------------------------------------------------------------------------------
# Post
#-------------------------------------------------------------------------------

schema =
  email:
    type: 'email'
  password:
    type: 'string'

exports.post = (req, res) ->

  async.waterfall [

    (callback) ->

      return Validate.isValid(req.body, schema, callback)

    (callback) ->

      User.findOne
        email: req.body.email
      .exec (err, user) ->
        return callback err if err

        if user is null
          return callback new Err.BadRequest
            text: 'User could not be found.'

        return callback null, user

      return

    (user, callback) ->

      password = req.body.password
      salt     = user.salt
      algorithm = user.algorithm

      crypto.pbkdf2 password, salt, user.rounds, 32, algorithm, (err, key) ->
        if err
          return callback new Err.BadRequest
            text: 'Could not look up username / password.'
        if user.key is key.toString('hex')
          return callback null, user
        else
          return callback new Err.BadRequest
            text: 'Invalid username or password.'

      return

    (user, callback) ->

      if user isnt null

        # If login was successful then
        # Save user data to their session.

        req.session.user = user

        # WIP Setting up a remember me.

        # Create a remember me cookie containing
        # a random generated token.

        #res.cookie 'remember_me', randtoken.uid(16)

        return callback null, user

      else

        req.session.user = null
        return callback null

  ], (err, user) ->

    if err

      # Response error status and text.

      res
      .status err.status
      .json   err.text

    else

      res
      .status 201
      .json user

  return


#-------------------------------------------------------------------------------