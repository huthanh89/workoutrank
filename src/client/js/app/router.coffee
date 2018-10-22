
#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Landing = require './landing/module'
Main    = require './main/module'
User    = require './user/module'

#-------------------------------------------------------------------------------


Router =
    initialize: ->
        Landing.initialize()
        Main.initialize()
        User.initialize()
        return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = Router

#-------------------------------------------------------------------------------