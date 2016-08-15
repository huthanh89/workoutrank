#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_        = require 'lodash'
moment   = require 'moment'
async    = require 'async'
mongoose = require 'mongoose'
Err      = require '../../error'
Validate = require '../../validate'

#-------------------------------------------------------------------------------
# Models
#-------------------------------------------------------------------------------

User = mongoose.model('user')

#-------------------------------------------------------------------------------
# Schema for POST and PUT validation
#-------------------------------------------------------------------------------

schema =
  sunday:    []
  monday:    []
  tuesday:   []
  wednesday: []
  thursday:  []
  friday:    []
  saturday:  []

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

      user = _.pick user, [
        '_id'
        'email'
        'lastlogin'
        'birthday'
        'firstname'
        'lastname'
        'username'
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

    #(callback) ->

    #  return Validate.isValid(req.body, schema, callback)

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

      user.save (err, entry) ->
        return callback err.message if err
        return callback null, entry

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