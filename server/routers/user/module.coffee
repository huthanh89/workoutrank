#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_          = require 'lodash'
express    = require 'express'
middleware = require '../../middleware'
router     = express.Router()

#-------------------------------------------------------------------------------
# Route Middleware
#-------------------------------------------------------------------------------

middlewares = [
  middleware.isAuthenticated
]

#-------------------------------------------------------------------------------
# Path Routes.
#   Pass index to all routes.
#-------------------------------------------------------------------------------

index = (req, res, next) ->
  res.render 'index'
  return

router.get '/account', middlewares, index
router.get '/profile', middlewares, index

#-------------------------------------------------------------------------------
# Import Routes
#-------------------------------------------------------------------------------

User    = require './user/module'
Account = require './account/module'
Profile = require './profile/module'

#-------------------------------------------------------------------------------
# API Routes for Resources.
#-------------------------------------------------------------------------------

router.get '/api/user',    middlewares, User.get

router.get '/api/account', middlewares, Account.get

router.get '/api/profile', middlewares, Profile.get
router.put '/api/profile', middlewares, Profile.put

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = router

#-------------------------------------------------------------------------------