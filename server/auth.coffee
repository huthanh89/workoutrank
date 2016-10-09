#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_                = require 'lodash'
moment           = require 'moment'
async            = require 'async'
mongoose         = require 'mongoose'
passport         = require 'passport'
LocalStrategy    = require('passport-local').Strategy
FacebookStrategy = require('passport-facebook').Strategy
TwitterStrategy  = require('passport-twitter').Strategy
GoogleStrategy   = require('passport-google-oauth').OAuth2Strategy

#-------------------------------------------------------------------------------
# Import Models
#-------------------------------------------------------------------------------

User     = mongoose.model('user')
Facebook = mongoose.model('facebook')
Google   = mongoose.model('google')
Twitter  = mongoose.model('twitter')

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

# Store id in session. Parameter 'user' is passed in from strategy.
# After serializeUser, we'll go to the auth/callback handler.

exports.serializeUser = (profileID, done) ->
  return done null, profileID

# Called to find user with given id.

exports.deserializeUser = (id, done) ->
  User.findOne
    $or: [
      _id: id
    ,
      facebookID: id
    ,
      twitterID: id
    ,
      googleID: id
    ]
  .exec (err, user) ->
    done err, user
    return

exports.localStrategy = new LocalStrategy (username, password, callback) ->

  User.findOneAndUpdate
    username: username
    provider: 'local'
  ,
    lastlogin: moment()

  , (err, user) ->
    return callback(err) if err
    return callback(null, false, message: 'Incorrect username.') if !user
    return user.validPassword(password, callback)
  return

# Create an entry for facebook
# Instead of using facebook id, we make and use our own.
# and send that _id to be serialize in the session.

exports.facebookStrategy = new FacebookStrategy({
  clientID:     '1588504301452640'
  clientSecret: '672cb532bbaf22b5a565cdf5e15893c3'
  callbackURL:  '/auth/facebook/callback'
  profileFields: ['id', 'displayName', 'photos', 'email']
}, (accessToken, refreshToken, profile, done) ->

  async.waterfall [

    (callback) ->
      Facebook.findOne
        facebookID: profile.id
      .exec (err, facebook) ->
        return callback err if err
        return callback null, facebook

    (facebook, callback) ->

      return callback null, facebook if facebook

      if facebook is null
        Facebook.create
          facebookID:   profile.id
          name:         profile.displayName
          accessToken:  accessToken
          refreshToken: refreshToken
        , (err, facebook) ->
          return callback err if err
          return callback null, facebook

      return

    (facebook, callback) ->

      User.findOne
        facebookID: facebook._id
      .exec (err, user) ->
        return callback err if err
        return callback null, facebook, user

    (facebook, user, callback) ->

      return callback null, user unless user is null

      User.create
        facebookID:facebook._id
        provider: 'facebook'
      , (err, user) ->
        return callback err if err
        return callback null, user

    (user, callback) ->

      # Update lastlogin time.

      User.findOneAndUpdate
        _id: user._id
      ,
        lastlogin: moment()
      , (err, user) ->
        return callback err.message if err
        return callback null, user

  ], (err, user) ->

    return done err, user._id

  return
)

exports.twitterStrategy = new TwitterStrategy({
  consumerKey:    'FdE3OIEzPttU9Dw3Jf8xpAqPW'
  consumerSecret: 'ucZGlEOaDF8K7MIrYwz04biOD5JThbWk3kVvwFixCndKA2Upgo'
  callbackURL:    '/auth/twitter/callback'
}, (token, tokenSecret, profile, done) ->

  async.waterfall [

    (callback) ->
      Twitter.findOne
        twitterID: profile.id
      .exec (err, user) ->
        return callback err if err
        return callback null, user

    (twitter, callback) ->

      return callback null, twitter if twitter

      if twitter is null
        Twitter.create
          twitterID:   profile.id
          token:       token
          tokenSecret: tokenSecret
        , (err, twitter) ->
          return callback err if err
          return callback null, twitter

      return

    (twitter, callback) ->

      User.findOne
        twitterID: twitter._id
      .exec (err, user) ->
        return callback err if err
        return callback null, twitter, user

    (twitter, user, callback) ->

      return callback null, user unless user is null

      User.create
        twitterID: twitter._id
        provider:  'twitter'
      , (err, user) ->
        return callback err if err
        return callback null, user

    (user, callback) ->

      # Update lastlogin time.

      User.findOneAndUpdate
        _id: user._id
      ,
        lastlogin: moment()
      , (err, user) ->
        return callback err.message if err
        return callback null, user

  ], (err, user) ->

    return done err, user._id

  return
)

exports.googleStrategy = new GoogleStrategy({
  clientID:     '372505580779-p0ku93tjmq14n8lg5nv5et2uui8p8puh.apps.googleusercontent.com'
  clientSecret: 'Bo-8UYRGdX5NAkKYxgxvtdg5'
  callbackURL:  '/auth/google/callback'
}, (accessToken, refreshToken, profile, done) ->

  async.waterfall [

    (callback) ->
      Google.findOne
        googleID: profile.id
      .exec (err, google) ->
        return callback err if err
        return callback null, google

    (google, callback) ->

      return callback null, google if google

      if google is null
        Google.create
          googleID:     profile.id
          accessToken:  accessToken
          refreshToken: refreshToken
        , (err, google) ->
          return callback err if err
          return callback null, google

      return

    (google, callback) ->

      User.findOne
        twitterID: google._id
      .exec (err, user) ->
        return callback err if err
        return callback null, google, user

    (google, user, callback) ->

      return callback null, user unless user is null

      User.create
        googleID: google._id
        provider: 'google'
      , (err, user) ->
        return callback err if err
        return callback null, user

    (user, callback) ->

      # Update lastlogin time.

      User.findOneAndUpdate
        _id: user._id
      ,
        lastlogin: moment()
      , (err, user) ->
        return callback err.message if err
        return callback null, user

  ], (err, user) ->

    return done err, user._id

  return
)

exports.facebookAuthCallback = (req, res) ->
  res.redirect '/home'
  return

exports.twitterAuthCallback =  (req, res) ->
  res.redirect '/home'
  return

exports.googleAuthCallback = (req, res) ->
  res.redirect '/home'
  return

#-------------------------------------------------------------------------------
