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
MongoStore   = require('connect-mongo')(session)

require 'coffee-script/register'

#--------------------------------------------------------------
# Database and Models
#--------------------------------------------------------------

# Connect to Database.

mongoose.connect 'mongodb://localhost:27017/local'
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

app.use logger('dev')

# Handle cookie and session before defining routes.
# cookie parser should be used before the session.
# this order is required for the session to work.

app.use bodyParser.json()

app.use bodyParser.urlencoded(extended: false)

# Able to read client's cookie.
app.use cookieParser()

# Initialize session.
app.use session(
  secret: 'keyboard cat'
  resave: false
  saveUninitialized: true
  cookie: {}
  store: new MongoStore(mongooseConnection: mongoose.connection))

# Location of static files starting from the root or app.js.
app.use express.static(path.join(__dirname, '../static'))
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

# If next was called in router then an error occured.
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