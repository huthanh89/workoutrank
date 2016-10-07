#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_        = require 'lodash'
async    = require 'async'
express  = require 'express'
mongoose = require 'mongoose'
path     = require 'path'
Account  = require './account/module'
router   = express.Router()

#-------------------------------------------------------------------------------
# Models
#-------------------------------------------------------------------------------

User = mongoose.model('user')

#-------------------------------------------------------------------------------
# Router Level Middleware
#-------------------------------------------------------------------------------

router.use (req, res, next) ->

  res.redirect '/login' unless req.session.passport

  userID = req.session.passport.user

  User.findOne
    _id: userID
  , (err, user) ->

    if user is null
      res.redirect '/login'
    else if req.url.includes('api') and user.username not in ['tth']
      res.status 401
      res.end()
    else
      next()

    return

  return

#-------------------------------------------------------------------------------
# Serve Index.html
#-------------------------------------------------------------------------------

index = (req, res, next) ->
  res.render 'index'
  return

router.get '/accounts', index

#-------------------------------------------------------------------------------
# API Resources.
#-------------------------------------------------------------------------------

router.get '/api/accounts', Account.get

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = router

#-------------------------------------------------------------------------------