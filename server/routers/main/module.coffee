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

router.get  '/api/exercise', Exercise.get
router.post '/api/exercise', Exercise.post

router.post '/api/strength', Strength.Detail.post
router.get '/api/strength/:sid', Strength.Detail.get
router.put '/api/strength/:sid', Strength.Detail.put

router.get '/api/strength/:sid/log', Strength.Log.get

router.get '/api/log', Log.get

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = router

#-------------------------------------------------------------------------------