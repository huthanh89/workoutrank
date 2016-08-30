#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_       = require 'lodash'
express = require 'express'
router  = express.Router()

#-------------------------------------------------------------------------------
# Path Routes.
#   Pass index to all routes.
#-------------------------------------------------------------------------------

urls = [
  '/home'
  '/exercise'
  '/exercise/:type'
  '/calendar'
  '/schedule'
  '/strengths'
  '/strength/:sid'
  '/strength/:sid/log'
  '/weights'
  '/body'
  '/logs'
  '/log/:lid'
]

for url in urls
  router.get url, (req, res, next) ->
    res.render 'index'
    return

#-------------------------------------------------------------------------------
# Router Level Middleware
#-------------------------------------------------------------------------------

# If user does not have a session, then redirect them to the login page.
# Put up an unauthorized page.

router.use  (req, res, next) ->
  if req.url.includes('api') and _.isUndefined(req.session.user)
    res.status 401
    res.end()
  else
    next()
  return

#-------------------------------------------------------------------------------
# Import Routes
#-------------------------------------------------------------------------------

Home     = require './home/module'
Strength = require './strength/module'
Log      = require './log/module'
SLog     = require './slog/module'
WLog     = require './wlog/module'
Schedule = require './schedule/module'

#-------------------------------------------------------------------------------
# API Routes for Resources.
#-------------------------------------------------------------------------------

router.get '/api/home', Home.get

#-------------------------------------------------------------------------------
# Strengths
#-------------------------------------------------------------------------------

# Get all strength exercises belonging to a user.
router.get '/api/strengths', Strength.list

# Get a specific strength workout matching strength ID.
router.get '/api/strengths/:sid', Strength.get
router.put '/api/strengths/:sid', Strength.put

# Post a new strength exercise for an user.
router.post '/api/strengths', Strength.post

# Get all slog for a strength exercise.
router.get '/api/strengths/:sid/log', Strength.log

# Delete a strength exercise.
router.delete '/api/strengths/:sid', Strength.delete

#-------------------------------------------------------------------------------
# Strength Logs
#-------------------------------------------------------------------------------

# Get all slogs.
router.get '/api/slogs', SLog.list

# Post a new slog record.
router.post '/api/slogs', SLog.post

# Get a specific slog.
router.get '/api/slogs/:sid', SLog.get

# Edit a specific slog record.
router.put '/api/slogs/:sid', SLog.put

# Delete a specific slog record.
router.delete '/api/slogs/:sid', SLog.delete

#-------------------------------------------------------------------------------
# ALL Logs
#-------------------------------------------------------------------------------

# Get all logs.
router.get '/api/logs', Log.get

#-------------------------------------------------------------------------------
# Schedule
#-------------------------------------------------------------------------------

# Post a new schedule record.
router.get '/api/schedule', Schedule.get

# Post a new schedule record.
router.post '/api/schedule', Schedule.post

# Edit schedules.
router.put '/api/schedule/:sid', Schedule.put

#-------------------------------------------------------------------------------
# Weight Logs
#-------------------------------------------------------------------------------

# Get all slogs.
router.get '/api/wlogs', WLog.list

# Post a new wlog record.
router.post '/api/wlogs', WLog.post

# Get a specific wlog.
router.get '/api/wlogs/:sid', WLog.get

# Edit a specific wlog record.
router.put '/api/wlogs/:sid', WLog.put

# Delete a specific wlog record.
router.delete '/api/wlogs/:sid', WLog.delete

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = router

#-------------------------------------------------------------------------------