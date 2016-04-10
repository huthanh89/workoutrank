#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------



#-------------------------------------------------------------------------------

class BadRequest
  status: 401
  title: 'Bad Request'
  body:  'The server cannot or will not process the request due to an apparent client error (e.g., malformed request syntax, invalid request message framing, or deceptive request routing'

class Unauthorized
  status: 401
  title: 'Unauthorized'
  body:  'User does not have the necessary credentials'

class Forbidden
  status: 401
  title: 'Forbidden'
  body:  'User does not have the necessary permissions for the resource'

class NotFound
  status: 401
  title: 'Not Found'
  body:  'The requested resource could not be found'

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.BadRequest   = BadRequest
module.exports.Unauthorized = Unauthorized
module.exports.Forbidden    = Forbidden
module.exports.NotFound     = NotFound

#-------------------------------------------------------------------------------