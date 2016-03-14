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
        email: 'admin'
      .exec (err, user) ->
        return callback err if err
        return callback null, user

      return

    (user, callback) ->

      console.log '-------------------'

      # If login was successful then
      # Save user data to their session.

      req.session.user = user

      # NOT SURE WHAT TO DO WITH THIS COOKIE
      # Create a remember me cookie containing
      # a random generated token.

      #res.cookie 'remember_me', randtoken.uid(16)

      return callback null, user


  ], (err, result) ->

    console.log 'error', err if err

    res
    .status 201
    .json result

  return


#-------------------------------------------------------------------------------