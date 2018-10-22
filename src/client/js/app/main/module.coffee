#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Home     = require './home/module'
Strength = require './strength/module'
Weight   = require './weight/module'

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

exports.initialize = ->
    new Home.Router()
    new Strength.Router()
    new Weight.Router()
    return
    
#-------------------------------------------------------------------------------
