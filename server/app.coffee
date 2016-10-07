#--------------------------------------------------------------
# Coffeescript plugin to read .coffee files.
#--------------------------------------------------------------

require 'coffee-script/register'

#--------------------------------------------------------------
# Register all models to mongoose object.
#--------------------------------------------------------------

require './models/facebook'
require './models/feedback'
require './models/google'
require './models/schedule'
require './models/slog'
require './models/strength'
require './models/token'
require './models/twitter'
require './models/user'
require './models/wlog'

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
auth         = require './auth'

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
# Configure passport.
#--------------------------------------------------------------

# Configure and initialize passport

# Store id in session. Parameter 'user' is passed in from strategy.
# After serializeUser, we'll go to the auth/callback handler.

passport.serializeUser auth.serializeUser

# Called to find user with given id.

passport.deserializeUser auth.deserializeUser

passport.use auth.localStrategy
passport.use auth.facebookStrategy
passport.use auth.twitterStrategy
passport.use auth.googleStrategy

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

app.use passport.initialize()
app.use passport.session()

app.get '/auth/facebook', passport.authenticate('facebook')
app.get '/auth/facebook/callback', passport.authenticate('facebook'), auth.facebookAuthCallback

app.get '/auth/twitter', passport.authenticate('twitter' )
app.get '/auth/twitter/callback', passport.authenticate('twitter' ), auth.twitterAuthCallback

app.get '/auth/google', passport.authenticate('google',
  scope: 'https://www.googleapis.com/auth/plus.login'
)

app.get '/auth/google/callback', passport.authenticate('google',
  scope: 'https://www.googleapis.com/auth/plus.login'
), auth.googleAuthCallback

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

# By the time the user gets here, there is no more route handlers.
# Return a NOT FOUND 404 error and render the error page.

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
