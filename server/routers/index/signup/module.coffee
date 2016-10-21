#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_         = require 'lodash'
moment    = require 'moment'
async     = require 'async'
request   = require 'request'
requestIp = require 'request-ip'
mongoose  = require 'mongoose'
crypto    = require 'crypto'
Validate  = require '../../validate'
Data      = require './data'

#-------------------------------------------------------------------------------
# Models
#-------------------------------------------------------------------------------

User = mongoose.model('user')

#-------------------------------------------------------------------------------
# Data
#   Recaptcha secret used to check if captcha response from client is correct.
#-------------------------------------------------------------------------------

RecaptchaSecret = '6LeGeBwTAAAAAJB1zR16oRVEPdZ-tYuOB2g9gY-0'

#-------------------------------------------------------------------------------
# Sanitize given string
#-------------------------------------------------------------------------------

sanitize = (string) -> string.trim().toLowerCase().replace(' ', '')

#-------------------------------------------------------------------------------
# Post
#-------------------------------------------------------------------------------

schema =
  captcha: []
  email: [
    method: 'isEmail'
  ,
    method: 'isLength'
    options:
      min: 4
      max: 35
  ]
  username: [
    method: 'isLength'
    options:
      min: 2
      max: 25
  ]
  password: [
    method: 'isLength'
    options:
      min: 4
      max: 20
  ]

exports.post = (req, res, next) ->

  email    = sanitize req.body.email
  username = sanitize req.body.username

  async.waterfall [

    (callback) ->

      for item in Data.blacklist
        if username is item
          return callback 'Bad username. Choose a different username'

      return callback null

    (callback) ->

      clientIp = requestIp.getClientIp(req)

      request.post
        url: 'https://www.google.com/recaptcha/api/siteverify'
        formData:
          secret:   RecaptchaSecret
          remoteIP: clientIp
          response: req.body.captcha
      , (error, response, body) ->
          return callback error if error
          body = JSON.parse(body)
          if body.success is false
            return callback 'Failed reCaptcha verification.'
          return callback null

      return

    (callback) ->

      return Validate.isValid(req.body, schema, callback)

    (callback) ->

      User.count
        email: email
      , (err, count) ->
          if count > 0
            return callback 'Email has been taken. Choose a different email.'
          else
            return callback null
      return

    (callback) ->

      User.count
        username: username
      , (err, count) ->
        if count > 0
          return callback 'Username has been taken. Choose a different username.'
        else
          return callback null
      return

    (callback) ->

      salt = crypto.randomBytes(32)

      return callback null, salt.toString('hex')

    (salt, callback) ->

      password = req.body.password
      salt     = salt.toString('hex')

      crypto.pbkdf2 password, salt, 10000, 32, 'sha512', (err, key) ->
        return callback 'Could not process new password.' if err
        return callback null, salt, key.toString('hex')

      return

    (salt, key, callback) ->

      User.create
        auth:      1
        created:   moment()
        lastlogin: moment()
        firstname: req.body.firstname
        lastname:  req.body.lastname
        email:     email
        username:  username
        gender:    req.body.gender
        salt:      salt
        key:       key
        algorithm: 'sha512'
        rounds:    10000
        provider: 'local'
      , (err, user) ->

        if err?.code is 11000
          return callback 'There was a problem. Cannot create new account.'

        return callback err if err
        return callback null, user.getPublicFields()

      return

  ], (err, user) ->

    # If there was an error then response with error status and text.

    if err
      res
      .status 400
      .json   err

    else

      req.login user._id, (err) ->

        if err
          res
          .status 400
          .json   err

        else

          # Send 201 status for successful record creation.

          res
          .status 201
          .json   user

      return

  return

#-------------------------------------------------------------------------------