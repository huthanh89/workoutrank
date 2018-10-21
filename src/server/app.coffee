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
compression  = require 'compression'
MongoStore   = require('connect-mongo')(session)
passport     = require 'passport'
auth         = require './auth'
config       = require './config'
routers      = require './routers/module'

#--------------------------------------------------------------
# Create Express App
#--------------------------------------------------------------

app  = express()

#--------------------------------------------------------------
# APP configurations for headers etc.
#--------------------------------------------------------------

# Tell express to look for views in the following directory.

app.set("views", path.join(__dirname, "/dist"));

# Set view engine to be interpret as html.

app.set('view engine', 'html');

# Parse request and append body data to req object.

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
# Database Connection
#--------------------------------------------------------------

# Handle deprecated "mpromise" library warning.

mongoose.Promise = global.Promise

# Connect to Database.

mongoose.connect config.databaseUrl, 
  {
    useNewUrlParser: true,
    autoIndex: false 
  }

db = mongoose.connection

db.on 'error', console.error.bind(console, 'MongoDB Connection Error:')

db.on 'open', ->
  console.log 'MongoDb connection opened'
  return

#--------------------------------------------------------------
# Router level Middlewares
#--------------------------------------------------------------

app.use routers.indexRouter
app.use routers.mainRouter
app.use routers.userRouter

#--------------------------------------------------------------
# Listen on port
#--------------------------------------------------------------

app.listen 5000, () => console.log('Math App listening on port 5000')

#--------------------------------------------------------------
# Exports
#--------------------------------------------------------------

module.exports = app

#--------------------------------------------------------------
