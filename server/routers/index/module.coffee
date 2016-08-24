#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Err     = require '../error'
express = require 'express'
router  = express.Router()

#-------------------------------------------------------------------------------
# Import Routes
#-------------------------------------------------------------------------------

feedback = require './feedback/module'
signup   = require './signup/module'
login    = require './login/module'
logout   = require './logout/module'

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
router.get '/about',    index
router.get '/feedback', index

#-------------------------------------------------------------------------------
# API Routes for Resources.
#-------------------------------------------------------------------------------

router.post '/api/feedback', feedback.post
router.post '/api/signup',   signup.post
router.post '/api/login',    login.post
router.post '/api/logout',   logout.post

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = router

#-------------------------------------------------------------------------------