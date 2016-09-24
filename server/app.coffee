#--------------------------------------------------------------
# Imports
#--------------------------------------------------------------

express      = require('express')
path         = require('path')
favicon      = require('serve-favicon')
logger       = require('morgan')
mongoose     = require('mongoose')
bodyParser   = require('body-parser')
cookieParser = require('cookie-parser')
session      = require('express-session')
passport     = require('passport')
http         = require('http')
compression  = require('compression')
MongoStore   = require('connect-mongo')(session)

require 'coffee-script/register'

#--------------------------------------------------------------
# Database and Models
#--------------------------------------------------------------

# Connect to Database.

#mongoose.connect 'mongodb://localhost:27017/local'
mongoose.connect 'mongodb://54.201.171.251:27017/local'

db = mongoose.connection
db.on 'error', console.error.bind(console, 'connection error:')
db.on 'open', ->
  console.log 'MongoDb connection opened.'
  return

#--------------------------------------------------------------
# Create Schemas from models
#--------------------------------------------------------------

require('./models/user') mongoose
require('./models/strength') mongoose
require('./models/slog') mongoose
require('./models/wlog') mongoose
require('./models/schedule') mongoose
require('./models/feedback') mongoose
require('./models/token') mongoose

#--------------------------------------------------------------
# Create App
#--------------------------------------------------------------

app = express()

#--------------------------------------------------------------
# Create server using app.
#--------------------------------------------------------------

server = http.createServer(app)

#--------------------------------------------------------------
# Application setup
#--------------------------------------------------------------

# view engine setup
# Set view's folder location and use jade as the engine
# starting from the root folder.
# /bin/www will look in this folder.

app.set 'views', './static'
app.set 'view engine', 'jade'

#--------------------------------------------------------------
# Application Level Middleware
#    It is important to note the the ordering of which
#    middleware is executed first before the other.
#--------------------------------------------------------------

app.use(require('prerender-node').set('prerenderToken', 'YOUR_TOKEN'))

app.use logger('dev')

# Compress all requests.

app.use(compression())

# Handle cookie and session before defining routes.
# cookie parser should be used before the session.
# this order is required for the session to work.

app.use bodyParser.json()

app.use bodyParser.urlencoded(extended: false)

# Able to read client's cookie.
app.use cookieParser()

# Initialize session.
# Session cookie will last for a week.
# Remove session from data base after an hour (3600 secs) of expiration.

app.use session
  secret: 'nerf this'
  resave: false
  saveUninitialized: true
  cookie: {}
  #cookie:
  #  maxAge: 604800
  unset: 'destroy'
  store: new MongoStore
    mongooseConnection: mongoose.connection
#    clear_interval: 3600
    clear_interval: 604800

# Middle ware for all pages.

app.get '*', (req, res, next) ->
  res.setHeader 'X-XSS-Protection', '1; mode=block'
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

# Location of static files starting from the root or app.js.
# Cache these staic files for 24 hours in maxAge.
app.use express.static(path.join(__dirname, '../static'), { maxAge: 86400000 })
app.use '/strength', express.static(path.join(__dirname, '../static'))
app.use '/strength/:sid', express.static(path.join(__dirname, '../static'))
app.use '/log', express.static(path.join(__dirname, '../static'))
app.use '/log/:lid', express.static(path.join(__dirname, '../static'))

# Define all routers.
# Can only require routes after express was initialized.

routers = require('./routers/module')

app.use '/', routers.indexRouter
app.use '/', routers.mainRouter
app.use '/', routers.userRouter

#The Page not Found 404 Route (ALWAYS Keep this as the last route)

app.get '*', (req, res) ->
  res.status 404
  res.render('404.jade')
  res.end()
  return

# If an error occurred in the app, catch it in the middleware.
# catch 404 and forward to error handler

app.use (err, req, res, next) ->
  console.log 'ERROR', err
  console.trace()
  res.render 'error', error: err
  return

app.use (err, req, res, next) ->
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
