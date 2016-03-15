#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment   = require 'moment'
async    = require 'async'
mongoose = require('mongoose')

#-------------------------------------------------------------------------------
# Models
#-------------------------------------------------------------------------------

User     = mongoose.model('user')
Exercise = mongoose.model('exercise')

#-------------------------------------------------------------------------------
# Get
#-------------------------------------------------------------------------------

exports.get = (req, res) ->

  async.waterfall [

    (callback) ->

      User.findOne
        email: 'admin'
      , exec (err, user) ->
        return callback err if err
        return callback null, user

      return

  ], (err, entry) ->

    console.log 'error', err if err

    res.json entry

    return

  return

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

    (user, callback) ->

      Exercise.create
        user:     user._id
        strength: []
      , (err, exercise) ->
        return callback err if err
        return callback null, user

      return callback null, user

  ], (err, result) ->

    console.log err if err

    res
    .status 201
    .json result

    return

  return

#-------------------------------------------------------------------------------