#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Profile = require './profile/module'
Account = require './account/module'

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

exports.initialize = ->
    new Profile.Router()
    new Account.Router()
    return
    
#-------------------------------------------------------------------------------
