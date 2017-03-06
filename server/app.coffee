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
require './models/strength'
require './models/slog'
require './models/cardio'
require './models/clog'
require './models/token'
require './models/twitter'
require './models/user'
require './models/wlog'
require './models/image'

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
config       = require './config'
routers      = require './routers/module'

#--------------------------------------------------------------
# Database Connection
#--------------------------------------------------------------

# Connect to Database.

#mongoose.connect config.developmentURL
mongoose.connect config.productionURL

db = mongoose.connection

db.on 'error', console.error.bind(console, 'connection error:')

db.on 'open', ->
  console.log 'MongoDb connection opened.'
  return

#--------------------------------------------------------------
# Configure and initialize passport.
#--------------------------------------------------------------

passport.serializeUser auth.serializeUser
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
# APP configurations for headers etc.
#--------------------------------------------------------------

app.use logger('dev')

# Compress all requests.

app.use compression()

# Handle cookie and session before defining routes.
# cookie parser should be used before the session.
# this order is required for the session to work.

app.use bodyParser.json
  limit: '8mb'
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

app.use (req, res, next) ->
  res.setHeader    'X-XSS-Protection', '1; mode=block'
  res.removeHeader 'server'
  res.removeHeader 'x-powered-by'
  next()
  return

#--------------------------------------------------------------
# Top Level Route Handlers
#--------------------------------------------------------------

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

app.use '/admin', adminApp

app.use routers.indexRouter
app.use routers.mainRouter
app.use routers.userRouter

# Location of static files starting from the root or app.js.
# Cache these static files for 24 hours in maxAge.
# Set expiration of static files as well for SEO optimization.

for url in [
  ''
  '/cardio'
  '/cardio/:cid'
  '/strength'
  '/strength/:sid'
  '/log'
  '/log/:lid'
  '/admin'
]
  app.use url, (req, res, next) ->
    res.setHeader 'Expires', new Date(Date.now() + 2592000000).toUTCString()
    next()
    return
  , express.static(path.join(__dirname, '../static'), { maxAge: 86400000 })

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
  #console.log 'ERROR', err
  console.trace()
  res.render 'error', error: err
  return

#--------------------------------------------------------------
# Listen on port
#--------------------------------------------------------------

server.listen config.port, ->
  console.log 'Express server listening on port %d in %s mode',
    config.port, app.get('env')
  return

#--------------------------------------------------------------
# Exports
#--------------------------------------------------------------

module.exports = app

#--------------------------------------------------------------
