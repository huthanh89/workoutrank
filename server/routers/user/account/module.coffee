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

      id = req.session.passport.user

      return callback 'No Session ID' if id is undefined

      User
      .findOne
        _id: id
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
# PUT
#-------------------------------------------------------------------------------

module.put = (req, res, next) ->

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

      user.save (err, user) ->
        return callback 'No user found' if user is null
        return callback err.message if err
        return callback null, user.getPublicFields()

      return

    (user, callback) ->

      # Create a new wlog entry.

      WLog.create
        date:   moment()
        note:   req.body.note
        weight: req.body.weight
        user:   req.session.passport.user
      , (err) ->
        return callback err.errors if err
        return callback null, user
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
# Exports
#-------------------------------------------------------------------------------

module.exports = module

#-------------------------------------------------------------------------------