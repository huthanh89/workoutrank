#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Err       = require '../../error'
moment    = require 'moment'
async     = require 'async'
request   = require 'request'
requestIp = require 'request-ip'
mongoose  = require 'mongoose'
crypto    = require 'crypto'

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
# Post
#-------------------------------------------------------------------------------

exports.post = (req, res, next) ->

  async.waterfall [

    (callback) ->

      clientIp = requestIp.getClientIp(req)

      console.log req.body

      #XXX
      #return callback null

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
            return callback new Err.BadRequest
              text: 'Failed reCaptcha validation.'
          return callback null

      return

    (callback) ->

      salt = crypto.randomBytes(32)

      return callback null, salt.toString('hex')

    (salt, callback) ->

      password = req.body.password
      salt     = salt.toString('hex')

      crypto.pbkdf2 password, salt, 10000, 32, 'sha512', (err, key) ->
        console.log err if err
        return callback null, salt, key.toString('hex')

      return

    (salt, key, callback) ->

      User.create
        created:   moment()
        lastlogin: moment()
        firstname: req.body.firstname
        lastname:  req.body.lastname
        email:     req.body.email
        username:  req.body.username
        birthday:  req.body.birthday
        gender:    req.body.gender
        salt:      salt
        key:       key
        algorithm: 'sha512'
        rounds:    10000
      , (err, user) ->

        if err?.code is 11000
          return callback new Err.BadRequest
            text: 'Username has been taken'

        return callback err if err
        return callback null, user

      return

  ], (err, user) ->

    if err

      # Response error status and text.

      res
      .status err.status
      .json   err.text

    else

      req.session.user = user

      # Send 201 status for successful record creation.

      return res
      .status 201
      .json   user

  return

#-------------------------------------------------------------------------------