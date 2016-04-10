#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Err   = require '../error'
express = require 'express'
router  = express.Router()

#-------------------------------------------------------------------------------
# Import Routes
#-------------------------------------------------------------------------------

signup = require './signup/module'
login  = require './login/module'

#-------------------------------------------------------------------------------
# Path Routes.
#   Pass index to all routes.
#-------------------------------------------------------------------------------

index = (req, res, next) ->

  next()
#  res.render 'index'
  return

router.get '/',       index
router.get '/signup', index
router.get '/login',  index

router.use (req, res, next) ->
  console.log 'heresdfzz---------->'
  error = new Err.Forbidden()
  console.log error.text

  #next(error)
  #next()
  res.render 'hello', error: error

  return


#-------------------------------------------------------------------------------
# API Routes for Resources.
#-------------------------------------------------------------------------------

router.post '/api/signup', signup.post
router.post '/api/login', login.post

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = router

#-------------------------------------------------------------------------------