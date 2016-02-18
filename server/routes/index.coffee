#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

express = require 'express'
router  = express.Router()

#-------------------------------------------------------------------------------
# Import Routes
#-------------------------------------------------------------------------------

profile = require './profile/module'
signup  = require './signup/module'
login   = require './login/module'

#-------------------------------------------------------------------------------
# Path Routes.
#   Pass index to all routes.
#-------------------------------------------------------------------------------

index = (req, res, next) ->
  res.render 'index'
  return

router.get '/',         index
router.get '/signup',   index
router.get '/login',    index
router.get '/home',     index
router.get '/profile',  index
router.get '/exercise', index
router.get '/cardio',   index

#-------------------------------------------------------------------------------
# API Routes for Resources.
#-------------------------------------------------------------------------------

router.get '/api/profile', profile.get

router.post '/api/signup', signup.post

router.post  '/api/login', login.post

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = router

#-------------------------------------------------------------------------------