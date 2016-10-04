#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_        = require 'lodash'
express  = require 'express'
router   = express.Router()

#-------------------------------------------------------------------------------
# Router Level Middleware
#-------------------------------------------------------------------------------

router.use (req, res, next) ->

  res.redirect '/login' unless req.session.passport

  userID = req.session.passport.user

  if req.url.includes('api') and _.isUndefined(userID)
    res.status 401
    res.end()
  else if _.isUndefined(userID)
    res.redirect '/login'
  else
    next()

  return

#-------------------------------------------------------------------------------
# Path Routes.
#   Pass index to all routes.
#-------------------------------------------------------------------------------

index = (req, res, next) ->
  res.render 'index'
  return

router.get '/account', index
router.get '/profile', index

#-------------------------------------------------------------------------------
# Import Routes
#-------------------------------------------------------------------------------

User    = require './user/module'
Account = require './account/module'

#-------------------------------------------------------------------------------
# API Routes for Resources.
#-------------------------------------------------------------------------------

router.get '/api/user', User.get

router.get '/api/account', Account.get
router.put '/api/account/:id', Account.put

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = router

#-------------------------------------------------------------------------------