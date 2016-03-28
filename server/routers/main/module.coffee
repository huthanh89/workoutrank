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

Profile  = require './profile/module'
Exercise = require './exercise/module'
Strength = require './strength/module'
Log      = require './log/module'

#-------------------------------------------------------------------------------
# API Routes for Resources.
#-------------------------------------------------------------------------------

router.get  '/api/profile', Profile.get

# Get complete exercise belonging to a user.
router.get  '/api/exercise', Exercise.get
# Post any exercise for an user.
router.post '/api/exercise', Exercise.post
# Get all workout sessions of an exercise.
router.post '/api/strength', Strength.Detail.post
# Post a workout session.
router.post '/api/strength', Strength.Detail.post
# Get a workout session.
router.get '/api/strength/:sid', Strength.Detail.get
# Edit an workout session.
router.put '/api/strength/:sid', Strength.Detail.put
# Get all workout session for an exercise.
router.get '/api/strength/:sid/log', Strength.Log.get
# Get all logs.
router.get '/api/log', Log.get

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = router

#-------------------------------------------------------------------------------