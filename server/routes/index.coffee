#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

express = require 'express'
router  = express.Router()

#-------------------------------------------------------------------------------
# Import Routes
#-------------------------------------------------------------------------------

signup   = require './signup/module'
login    = require './login/module'
profile  = require './profile/module'
exercise = require './exercise/module'

#-------------------------------------------------------------------------------
# Path Routes.
#   Pass index to all routes.
#-------------------------------------------------------------------------------

index = (req, res, next) ->
  res.render 'index'
  return

router.get '/',               index
router.get '/signup',         index
router.get '/login',          index
router.get '/home',           index
router.get '/profile',        index
router.get '/exercise',       index
router.get '/exercise/:type', index
router.get '/cardio',         index
router.get '/stat',           index
router.get '/schdedule',      index
router.get '/log',            index
router.get '/multiplayer',    index


#-------------------------------------------------------------------------------
# API Routes for Resources.
#-------------------------------------------------------------------------------

router.get  '/api/profile',  profile.get

router.get  '/api/exercise', exercise.get
router.post '/api/exercise', exercise.post

router.post '/api/signup',   signup.post

router.post '/api/login',    login.post

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = router

#-------------------------------------------------------------------------------