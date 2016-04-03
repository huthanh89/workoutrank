#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment    = require 'moment'
async     = require 'async'
mongoose  = require 'mongoose'
randtoken = require 'rand-token'

#-------------------------------------------------------------------------------
# Models
#-------------------------------------------------------------------------------

User = mongoose.model('user')

#-------------------------------------------------------------------------------
# Post
#-------------------------------------------------------------------------------

exports.post = (req, res) ->

  async.waterfall [

    (callback) ->

      User.findOne
        email:    req.body.email
        password: req.body.password
      .exec (err, user) ->
        return callback err if err
        return callback null, user

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

    console.log 'error', err if err

    if user
      res
      .status 201
      .json user

    else
      res.send 'Not Authenticated'
      res.end()

  return


#-------------------------------------------------------------------------------