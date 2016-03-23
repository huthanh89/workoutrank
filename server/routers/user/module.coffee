#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

express = require 'express'
router  = express.Router()

#-------------------------------------------------------------------------------
# Import Routes
#-------------------------------------------------------------------------------

user = require './user/module'

#-------------------------------------------------------------------------------
# API Routes for Resources.
#-------------------------------------------------------------------------------

router.get '/api/user', user.get

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = router

#-------------------------------------------------------------------------------