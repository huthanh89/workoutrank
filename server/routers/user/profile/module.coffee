#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment    = require 'moment'
async     = require 'async'
mongoose  = require 'mongoose'
validator = require 'validator'

#-------------------------------------------------------------------------------
# Models
#-------------------------------------------------------------------------------

User  = mongoose.model('user')
WLog  = mongoose.model('wlog')
Image = mongoose.model('image')

#-------------------------------------------------------------------------------
# GET
#-------------------------------------------------------------------------------

module.get = (req, res) ->

  result = {}

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

        result.user = user.getPublicFields()

        return callback null
      return

    (callback) ->

      Image
      .findOne
        user: req.session.passport.user
        imageType: 'profile'
      .exec (err, image) ->

        return callback err if err
        result.image = image
        return callback null

      return

  ], (err) ->

    if err
      res
      .status 400
      .json   err

    else
      res
      .status 200
      .json result

    return

#-------------------------------------------------------------------------------
# PUT
#-------------------------------------------------------------------------------

module.put = (req, res) ->

  async.waterfall [

    (callback) ->

      return callback 'Bad Firstname' unless validator.isAlpha(req.body.firstname)
      return callback 'Bad Lastname' unless validator.isAlpha(req.body.lastname)

      return callback null

    (callback) ->

      id = req.session.passport.user
      return callback 'No Session ID' if id is undefined

      User.findOneAndUpdate
        _id: id
      ,
        email:     req.body.email
        firstname: req.body.firstname
        lastname:  req.body.lastname
        height:    req.body.height
        gender:    req.body.gender
        birthday:  req.body.birthday
      , (err, user) ->
        return callback 'No user found' if user is null
        return callback err.message if err
        return callback null, user

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

    (user, callback) ->

      if req.body.data.length is 0
        Image.findOneAndRemove
          user: req.session.passport.user
          imageType: 'profile'
        , (err) ->
          return callback err.errors if err
          return callback null, user

      else

        Image.findOneAndUpdate
          user: req.session.passport.user
          imageType: 'profile'
        ,
          uploadDate:       moment()
          lastModified:     req.body.lastModified
          lastModifiedDate: req.body.lastModifiedDate
          name:             req.body.name
          size:             req.body.size
          imageType:        req.body.imageType
          type:             req.body.type
          data:             req.body.data
          user:             req.session.passport.user
        , upsert: true
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
      .json user.getPublicFields()

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = module

#-------------------------------------------------------------------------------