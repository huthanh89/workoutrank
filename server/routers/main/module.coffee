#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

express = require 'express'
router  = express.Router()

#-------------------------------------------------------------------------------
# Router Level Middleware
#-------------------------------------------------------------------------------

# If user does not have a session, then redirect them to the login page.

router.use  (req, res, next) ->
  if req.session.user
    next()
  else
    res.redirect('/login')
  return

#-------------------------------------------------------------------------------
# Path Routes.
#   Pass index to all routes.
#-------------------------------------------------------------------------------

index = (req, res, next) ->
  res.render 'index'
  return

router.get '/home',              index
router.get '/profile',           index
router.get '/exercise',          index
router.get '/exercise/:type',    index
router.get '/cardio',            index
router.get '/stat',              index
router.get '/strength',          index
router.get '/strength/:sid',     index
router.get '/strength/:sid/log', index
router.get '/schedule',          index
router.get '/log',               index
router.get '/multiplayer',       index

#-------------------------------------------------------------------------------
# Import Routes
#-------------------------------------------------------------------------------

Home     = require './home/module'
Profile  = require './profile/module'
Strength = require './strength/module'
Log      = require './log/module'
SLog     = require './slog/module'

#-------------------------------------------------------------------------------
# API Routes for Resources.
#-------------------------------------------------------------------------------

router.get '/api/profile', Profile.get

router.get '/api/home', Home.get

#-------------------------------------------------------------------------------
# Strengths
#-------------------------------------------------------------------------------

# Get all strength exercises belonging to a user.
router.get '/api/strengths', Strength.list

# Get a specific strength workout matching strength ID.
router.get '/api/strengths/:sid', Strength.get

# Post a new strength exercise for an user.
router.post '/api/strengths', Strength.post

# Get all slog for a strength exercise.
router.get '/api/strengths/:sid/log', Strength.log

#-------------------------------------------------------------------------------
# Strength Logs
#-------------------------------------------------------------------------------

# Get all slogs from a user.
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
# Exports
#-------------------------------------------------------------------------------

module.exports = router

#-------------------------------------------------------------------------------