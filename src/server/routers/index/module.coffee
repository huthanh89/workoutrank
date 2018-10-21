#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

express  = require 'express'
passport = require 'passport'
router   = express.Router()

#-------------------------------------------------------------------------------
# Import Routes
#-------------------------------------------------------------------------------

feedback = require './feedback/module'
forgot   = require './forgot/module'
signup   = require './signup/module'
login    = require './login/module'
logout   = require './logout/module'
reset    = require './reset/module'

#-------------------------------------------------------------------------------
# Path Routes.
#   Pass index to all routes.
#-------------------------------------------------------------------------------

index = (req, res) ->
  res.render 'index'
  return

for url in [
  '/'
  '/signup'
  '/login'
  '/about'
  '/feedback'
  '/forgot'
  '/reset'
]
  router.use url, express.static(__dirname + '/dist')

router.get '/',         index
router.get '/signup',   index
router.get '/login',    index
router.get '/about',    index
router.get '/feedback', index
router.get '/forgot',   index
router.get '/reset',    index

#-------------------------------------------------------------------------------
# API Routes for Resources.
#-------------------------------------------------------------------------------

router.post '/api/feedback', feedback.post
router.post '/api/forgot',   forgot.post
router.post '/api/signup',   signup.post
router.post '/api/logout',   logout.post
router.post '/api/reset',    reset.post

# If successful login.

router.post '/api/login', passport.authenticate('local'), (req, res) ->
  res.status 200
  res.json {}
  return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = router

#-------------------------------------------------------------------------------