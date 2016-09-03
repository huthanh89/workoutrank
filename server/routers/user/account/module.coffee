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
WLog = mongoose.model('wlog')

#-------------------------------------------------------------------------------
# GET
#-------------------------------------------------------------------------------

module.get = (req, res, next) ->

  async.waterfall [

    (callback) ->

      User.findById req.session.user._id, (err, user) ->
        return callback err if err
        return callback null, user
      return

    (user, callback) ->

      user =_.pick user, [
        '_id'
        'email'
        'username'
        'firstname'
        'lastname'
        'height'
        'weight'
        'gender'
        'auth'
        'height'
        'birthday'
      ]

      callback null, user
      return

  ], (err, user) ->

    if err
      res
      .status 400
      .json   err

    return res.json user

#-------------------------------------------------------------------------------
# PUT
#-------------------------------------------------------------------------------

module.put = (req, res, next) ->

  async.waterfall [

    (callback) ->

      User.findById req.session.user._id, (err, user) ->
        return callback err if err
        return callback null, user
      return

    (user, callback) ->

      user.email     = req.body.email
      user.username  = req.body.username
      user.firstname = req.body.firstname
      user.lastname  = req.body.lastname
      user.height    = req.body.height
      user.gender    = req.body.gender
      user.birthday  = req.body.birthday

      user.save (err, entry) ->
        return callback err.message if err
        return callback null, entry

      return

    (user, callback) ->

      # Create a new wlog entry.

      WLog.create
        date:     moment()
        note:     ''
        weight:   req.body.weight
        user:     req.session.user._id
      , (err) ->
        return callback err.message if err
        return callback null, user
      return

  ], (err, user) ->

    if err
      res
      .status 400
      .json   err

    return res.json user

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = module

#-------------------------------------------------------------------------------