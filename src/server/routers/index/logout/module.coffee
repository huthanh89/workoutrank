
#-------------------------------------------------------------------------------
# Export
#-------------------------------------------------------------------------------

exports.post = (req, res) ->

  req.logout()

  # We cant redirect the user on server side. So send a 200 OK back to the client
  # and have them do any redirection via javascript client side.

  res
  .status 200
  .json {}

  return

#-------------------------------------------------------------------------------