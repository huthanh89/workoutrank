#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_ = require 'lodash'

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.isAuthenticated = (req, res, next) ->

  ###
  if req.xhr and not req.isAuthenticated()
    res
    .status 401
    .json   'Not logged in'

  else if not req.isAuthenticated()
    res.redirect '/login'

  else
    next()
###
  next()
  return


#-------------------------------------------------------------------------------
