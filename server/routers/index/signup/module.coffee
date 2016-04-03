#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment   = require 'moment'
async    = require 'async'
mongoose = require('mongoose')

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

      User.create
        created:   moment()
        lastlogin: moment()
        firstname: req.body.firstname
        lastname:  req.body.lastname
        email:     req.body.email
        password:  req.body.password
      , (err, user) ->
        return callback err if err
        return callback null, user

      return

  ], (err, user) ->

    console.log err if err

    req.session.user = user

    res
    .status 201
    .json user

    return

  return

#-------------------------------------------------------------------------------