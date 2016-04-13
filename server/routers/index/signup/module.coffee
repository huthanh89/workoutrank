#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment    = require 'moment'
Err       = require '../../error'
async     = require 'async'
request   = require 'request'
requestIp = require 'request-ip'
mongoose  = require 'mongoose'

#-------------------------------------------------------------------------------
# Models
#-------------------------------------------------------------------------------

User = mongoose.model('user')

#-------------------------------------------------------------------------------
# Data
#   Recaptcha secret used to check if captcha response from client is correct.
#-------------------------------------------------------------------------------

Secret = '6LeGeBwTAAAAAJB1zR16oRVEPdZ-tYuOB2g9gY-0'

#-------------------------------------------------------------------------------
# Post
#-------------------------------------------------------------------------------

exports.post = (req, res, next) ->

  async.waterfall [

    (callback) ->

      clientIp = requestIp.getClientIp(req)

      request.post
        url: 'https://www.google.com/recaptcha/api/siteverify'
        formData:
          secret:   Secret
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

      User.create
        created:   moment()
        lastlogin: moment()
        firstname: req.body.firstname
        lastname:  req.body.lastname
        email:     req.body.email
        password:  req.body.password
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

      return res
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