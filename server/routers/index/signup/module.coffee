#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment    = require 'moment'
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

exports.post = (req, res) ->

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
          return callback 'Failed reCaptcha validation.' if body.success is false
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
        return callback err if err
        return callback null, user

      return

  ], (error, user) ->

    if error

      # Send 400 status code for bad request.

      return res
      .status 400
      .json error

    else

      req.session.user = user

      # Send 201 status for successful record creation.

      return res
      .status 201
      .json user

  return

#-------------------------------------------------------------------------------