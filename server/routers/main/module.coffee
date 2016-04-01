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
router.get '/api/strengths', Strength.get

# Post a new strength exercise for an user.
router.post '/api/strengths', Strength.post

# Get all slog for an exercise.
router.get '/api/strengths/:sid/log', Strength.log

#-------------------------------------------------------------------------------
# Strength Logs
#-------------------------------------------------------------------------------

# Get all slogs.
router.get '/api/slogs', SLog.list

# Post a new workout session.
router.post '/api/slogs', SLog.post

# Get a specific session log.
router.get '/api/slogs/:sid', SLog.get

# Edit an workout session.
router.put '/api/slogs/:sid', SLog.put

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