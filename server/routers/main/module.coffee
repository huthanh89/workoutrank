#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_          = require 'lodash'
express    = require 'express'
middleware = require '../../middleware'
router     = express.Router()

#-------------------------------------------------------------------------------
# Route Middleware
#-------------------------------------------------------------------------------

middlewares = [
  middleware.isAuthenticated
]

#-------------------------------------------------------------------------------
# Path Routes.
#   Pass index to all routes.
#-------------------------------------------------------------------------------

urls = [
  '/home'
  '/exercise'
  '/calendar'
  '/schedule'
  '/strengths'
  '/cardios'
  '/weights'
  '/body'
  '/timeline'
]

for url in urls
  router.get url, middlewares,(req, res) ->
    res.render 'index'
    return

#-------------------------------------------------------------------------------
# Import Routes
#-------------------------------------------------------------------------------

Home     = require './home/module'
Strength = require './strength/module'
Cardio   = require './cardio/module'
Log      = require './log/module'
CLog     = require './clog/module'
SLog     = require './slog/module'
WLog     = require './wlog/module'
Schedule = require './schedule/module'

#-------------------------------------------------------------------------------
# XHR Middleware
#-------------------------------------------------------------------------------

middlewares = [
  middleware.isAuthenticated
]

#-------------------------------------------------------------------------------
# API Routes for Resources.
#-------------------------------------------------------------------------------

router.get '/api/home', middlewares, Home.get

#-------------------------------------------------------------------------------
# Strengths
#-------------------------------------------------------------------------------

# Get all strength exercises belonging to a user.
router.get '/api/strengths', middlewares, Strength.list

# Get a specific strength workout matching strength ID.
router.get '/api/strengths/:sid', middlewares, Strength.get
router.put '/api/strengths/:sid', middlewares, Strength.put

# Post a new strength exercise for an user.
router.post '/api/strengths', middlewares, Strength.post

# Get all slog for a strength exercise.
router.get '/api/strengths/:sid/log', middlewares, Strength.log

# Delete a strength exercise.
router.delete '/api/strengths/:sid', middlewares, Strength.delete

#-------------------------------------------------------------------------------
# Strength Logs
#-------------------------------------------------------------------------------

# Get all slogs.
router.get '/api/slogs', middlewares, SLog.list

# Post a new slog record.
router.post '/api/slogs', middlewares, SLog.post

# Get a specific slog.
router.get '/api/slogs/:sid', middlewares, SLog.get

# Edit a specific slog record.
router.put '/api/slogs/:sid', middlewares, SLog.put

# Delete a specific slog record.
router.delete '/api/slogs/:sid', middlewares, SLog.delete

#-------------------------------------------------------------------------------
# Cardio Conf
#-------------------------------------------------------------------------------

router.get    '/api/cardios',      middlewares, Cardio.list
router.get    '/api/cardios/:cid', middlewares, Cardio.get
router.put    '/api/cardios/:cid', middlewares, Cardio.put
router.post   '/api/cardios',      middlewares, Cardio.post
router.delete '/api/cardios/:cid', middlewares, Cardio.delete

#-------------------------------------------------------------------------------
# Cardio Logs
#-------------------------------------------------------------------------------

router.get    '/api/clogs',      middlewares, CLog.list
router.post   '/api/clogs',      middlewares, CLog.post
router.get    '/api/slogs/:cid', middlewares, CLog.get
router.put    '/api/clogs/:cid', middlewares, CLog.put
router.delete '/api/clogs/:cid', middlewares, CLog.delete

#-------------------------------------------------------------------------------
# ALL Logs
#-------------------------------------------------------------------------------

# Get all logs.
router.get '/api/logs', middlewares, Log.get

#-------------------------------------------------------------------------------
# Schedule
#-------------------------------------------------------------------------------

# Post a new schedule record.
router.get '/api/schedule', middlewares, Schedule.get

# Post a new schedule record.
router.post '/api/schedule', middlewares, Schedule.post

# Edit schedules.
router.put '/api/schedule/:sid', middlewares, Schedule.put

#-------------------------------------------------------------------------------
# Weight Logs
#-------------------------------------------------------------------------------

# Get all slogs.
router.get '/api/wlogs', middlewares, WLog.list

# Post a new wlog record.
router.post '/api/wlogs', middlewares, WLog.post

# Get a specific wlog.
router.get '/api/wlogs/:sid', middlewares, WLog.get

# Edit a specific wlog record.
router.put '/api/wlogs/:sid', middlewares, WLog.put

# Delete a specific wlog record.
router.delete '/api/wlogs/:sid', middlewares, WLog.delete

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = router

#-------------------------------------------------------------------------------