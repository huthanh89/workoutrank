#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_         = require 'lodash'
moment    = require 'moment'
async     = require 'async'
mongoose  = require 'mongoose'
crypto    = require 'crypto'

#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

nodemailer  = require 'nodemailer'

#-------------------------------------------------------------------------------
# Models
#-------------------------------------------------------------------------------

User  = mongoose.model('user')
Token = mongoose.model('token')

#-------------------------------------------------------------------------------

# create reusable transporter object using the default SMTP transport
#transporter = nodemailer.createTransport('smtps://vietxoulja12%40gmail.com:xoujas12@smtp.gmail.com')
smtpTransport = require('nodemailer-smtp-transport')
transporter = nodemailer.createTransport smtpTransport
  service: 'gmail'
  auth:
    user: 'vietxoulja12@gmail.com'
    pass: ''

#-------------------------------------------------------------------------------
# Post
#-------------------------------------------------------------------------------

exports.post = (req, res) ->

  mailOptions =
    from:    '"W.R Support Team" <support@workoutrank.com>'
    subject: 'Password Reset'
    text:    ''

  async.waterfall [

    (callback) ->

      User.findOne
        $or: [
          username: req.body.user
        , email: req.body.user
        ]

      .exec (err, user) ->
        return callback err if err

        if user is null
          return callback 'Username / Email could not be found.'

        return callback null, user

    (user, callback) ->

      token = crypto.randomBytes(16).toString('hex')

      mailOptions.to   = user.email
      mailOptions.html = "<a href='https://workoutrank.com/reset?user=#{req.body.user}&token=#{token}'>Click here to reset your password.<a>"

      Token.create
        date:  moment()
        token: token
        user:  req.body.user
      , (err, token) ->
        return callback err.message if err
        return callback null

    (callback) ->

      # send mail with defined transport object

      transporter.sendMail mailOptions, (error, info) ->
        return error if error
        return

      return callback null

  ], (err) ->

    # Response error status and text.

    if err
      res
      .status 400
      .json   err

    else
      res
      .status 201
      .json req.body

  return

#-------------------------------------------------------------------------------
