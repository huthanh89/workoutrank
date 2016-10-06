#--------------------------------------------------------------
# Coffeescript plugin to read .coffee files.
#--------------------------------------------------------------

require 'coffee-script/register'

#--------------------------------------------------------------
# Imports
#--------------------------------------------------------------

async        = require 'async'
moment       = require 'moment'
express      = require 'express'
path         = require 'path'
favicon      = require 'serve-favicon'
logger       = require 'morgan'
mongoose     = require 'mongoose'
bodyParser   = require 'body-parser'
cookieParser = require 'cookie-parser'
session      = require 'express-session'
http         = require 'http'
compression  = require 'compression'
MongoStore   = require('connect-mongo')(session)
passport     = require 'passport'
LocalStrategy    = require('passport-local').Strategy
FacebookStrategy = require('passport-facebook').Strategy
TwitterStrategy  = require('passport-twitter').Strategy
GoogleStrategy   = require('passport-google-oauth').OAuth2Strategy

#--------------------------------------------------------------
# Database Connection
#--------------------------------------------------------------

# Connect to Database.

mongoose.connect 'mongodb://localhost:27017/local'
#mongoose.connect 'mongodb://54.201.171.251:27017/local'

db = mongoose.connection

db.on 'error', console.error.bind(console, 'connection error:')
db.on 'open', ->
  console.log 'MongoDb connection opened.'
  return

#--------------------------------------------------------------
# Register schemas models
#--------------------------------------------------------------

require('./models/user')     mongoose
require('./models/strength') mongoose
require('./models/slog')     mongoose
require('./models/wlog')     mongoose
require('./models/schedule') mongoose
require('./models/feedback') mongoose
require('./models/token')    mongoose
require('./models/facebook') mongoose
require('./models/twitter')  mongoose
require('./models/google')   mongoose

#-------------------------------------------------------------------------------
# Import Models
#-------------------------------------------------------------------------------

User     = mongoose.model('user')
Facebook = mongoose.model('facebook')
Twitter  = mongoose.model('twitter')
Google   = mongoose.model('google')

#--------------------------------------------------------------
# Create App and sub app.
#--------------------------------------------------------------

app      = express()
adminApp = require './admin/app'

#--------------------------------------------------------------
# Create server using app.
#--------------------------------------------------------------

server = http.createServer(app)

#--------------------------------------------------------------
# Configure view engine to render EJS templates.
#
#   Set view's folder location and use jade as the engine
#   starting from the root folder.
#   /bin/www will look in this folder.
#--------------------------------------------------------------

app.set 'views', './static'
app.set 'view engine', 'jade'

#--------------------------------------------------------------
# APP Configurations
#--------------------------------------------------------------

app.use(require('prerender-node').set('prerenderToken', 'YOUR_TOKEN'))

app.use logger('dev')

# Compress all requests.

app.use(compression())

# Handle cookie and session before defining routes.
# cookie parser should be used before the session.
# this order is required for the session to work.

app.use bodyParser.json()

app.use bodyParser.urlencoded
  extended: false

# Able to read client's cookie.

app.use cookieParser()

# Initialize session.
# Session cookie will last for a week.
# Remove session from data base after an hour (3600 secs) of expiration.

app.use session
  secret:           'nerf this'
  resave:            false
  saveUninitialized: true
  cookie:            {}
  unset:            'destroy'
  store: new MongoStore
    mongooseConnection: mongoose.connection
    clear_interval:     604800

# Configure and initialize passport

# Store id in session. Parameter 'user' is passed in from strategy.
# After serializeUser, we'll go to the auth/callback handler.

passport.serializeUser (profileID, done) ->
  console.log 'SERIAL', profileID
  return done null, profileID

# Called to find user with given id.

passport.deserializeUser (id, done) ->

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

# Create an entry for facebook
# Instead of using facebook id, we make and use our own.
# and send that _id to be serialize in the session.

passport.use new FacebookStrategy({
  clientID:     '1588504301452640'
  clientSecret: '672cb532bbaf22b5a565cdf5e15893c3'
  callbackURL:  '/auth/facebook/callback'
  profileFields: ['id', 'displayName', 'photos', 'email']
}, (accessToken, refreshToken, profile, done) ->

  async.waterfall [

    (callback) ->
      Facebook.findOne
        facebookID: profile.id
      .exec (err, user) ->
        return callback err if err
        return callback null, user

    (user, callback) ->

      return callback null, user if user

      if user is null
        Facebook.create
          facebookID:   profile.id
          name:         profile.displayName
          accessToken:  accessToken
          refreshToken: refreshToken
        , (err, user) ->
            return callback err if err
            return callback null, user

      return

  ], (err, user) ->

    return done err, user._id

  return
)

passport.use new LocalStrategy((username, password, callback) ->

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
)

passport.use new TwitterStrategy({
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

    (user, callback) ->

      return callback null, user if user

      if user is null
        Twitter.create
          twitterID:   profile.id
          token:       token
          tokenSecret: tokenSecret
        , (err, user) ->
          return callback err if err
          return callback null, user

      return

  ], (err, user) ->

    return done err, user._id

  return
)

passport.use new GoogleStrategy({
  clientID:     '372505580779-p0ku93tjmq14n8lg5nv5et2uui8p8puh.apps.googleusercontent.com'
  clientSecret: 'Bo-8UYRGdX5NAkKYxgxvtdg5'
  callbackURL:  '/auth/google/callback'
}, (accessToken, refreshToken, profile, done) ->

  async.waterfall [

    (callback) ->
      Google.findOne
        googleID: profile.id
      .exec (err, user) ->
        return callback err if err
        return callback null, user

    (user, callback) ->

      return callback null, user if user

      if user is null
        Google.create
          googleID:     profile.id
          accessToken:  accessToken
          refreshToken: refreshToken
        , (err, user) ->
          return callback err if err
          return callback null, user

      return

  ], (err, user) ->

    return done err, user._id

  return
)
app.use passport.initialize()
app.use passport.session()

app.get '/auth/facebook', passport.authenticate('facebook')

app.get '/auth/facebook/callback', passport.authenticate('facebook'), (req, res) ->

  async.waterfall [

    (callback) ->
      User.findOne
        facebookID: req.session.passport.user
      .exec (err, user) ->
        return callback err if err
        return callback null, user

    (user, callback) ->

      return callback null, user unless user is null

      User.create
        facebookID: req.session.passport.user
        provider:   'facebook'
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

    if err
      console.log 'ERROR', err
      res.status 404
    else
      res.redirect '/home'

  return

app.get '/auth/twitter', passport.authenticate('twitter' )

app.get '/auth/twitter/callback', passport.authenticate('twitter' ),  (req, res) ->

  async.waterfall [
    (callback) ->
      User.findOne
        twitterID: req.session.passport.user
      .exec (err, user) ->
        return callback err if err
        return callback null, user

    (user, callback) ->

      return callback null, user unless user is null

      User.create
        twitterID: req.session.passport.user
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

    if err
      console.log 'ERROR', err
      res.status 404
    else


      res.redirect '/home'

  return

app.get '/auth/google', passport.authenticate('google',
  scope: 'https://www.googleapis.com/auth/plus.login'
)

app.get '/auth/google/callback', passport.authenticate('google',
  scope: 'https://www.googleapis.com/auth/plus.login'
), (req, res) ->

  async.waterfall [

    (callback) ->
      User.findOne
        googleID: req.session.passport.user
      .exec (err, user) ->
        return callback err if err
        return callback null, user

    (user, callback) ->

      return callback null, user unless user is null

      User.create
        googleID: req.session.passport.user
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

    if err
      console.log 'ERROR', err
      res.status 404
    else
      res.redirect '/home'

  return

#--------------------------------------------------------------
# Top Level Route Handlers
#--------------------------------------------------------------

# Middle ware for all pages.

app.get '*', (req, res, next) ->
  res.setHeader    'X-XSS-Protection', '1; mode=block'
  res.removeHeader 'server'
  res.removeHeader 'x-powered-by'
  next()
  return

# Set expiration date header for images. (1 month from now)

app.get '/images/*', (req, res, next) ->
  if req.url.indexOf('/images/') == 0 or req.url.indexOf('/stylesheets/') == 0
    res.setHeader 'Cache-Control', 'public, max-age=2592000'
    res.setHeader 'Expires', new Date(Date.now() + 2592000000).toUTCString()
  next()
  return

app.get '/favicon.ico', (req, res, next) ->
  res.setHeader 'Cache-Control', 'public, max-age=2592000'
  res.setHeader 'Expires', new Date(Date.now() + 2592000000).toUTCString()
  next()
  return

# Define all routers.
# Can only require routes after express was initialized.

routers = require('./routers/module')

app.use routers.indexRouter
app.use routers.mainRouter
app.use routers.userRouter

# Location of static files starting from the root or app.js.
# Cache these static files for 24 hours in maxAge.

staticFiles = express.static(path.join(__dirname, '../static'), { maxAge: 86400000 })

app.use                   staticFiles
app.use '/strength',      staticFiles
app.use '/strength/:sid', staticFiles
app.use '/log',           staticFiles
app.use '/log/:lid',      staticFiles
app.use '/auth/facebook', staticFiles
app.use '/auth',          staticFiles
app.use '/admin',         adminApp

# The Page not Found 404 Route (ALWAYS Keep this as the last route)

app.get '*', (req, res) ->
  res.status 404
  res.render('404.jade')
  res.end()
  return

# If an error occurred in the app, catch it in the middleware.
# catch 404 and forward to error handler

app.use (err, req, res) ->
  console.log 'ERROR', err
  console.trace()
  res.render 'error', error: err
  return

app.get (err, req, res, next) ->
  err = new Error('Not Found, Server Ended.')
  err.status = 404
  next err
  return

#--------------------------------------------------------------
# Listen on port
#--------------------------------------------------------------

port = 5000

server.listen port, ->
  console.log 'Express server listening on port %d in %s mode',
    port, app.get('env')
  return

#--------------------------------------------------------------
# Exports
#--------------------------------------------------------------

module.exports = app

#--------------------------------------------------------------
