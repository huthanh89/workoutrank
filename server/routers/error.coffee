#-------------------------------------------------------------------------------
# HTTP Response code
#-------------------------------------------------------------------------------

class BadRequest
  status: 401
  title: 'Bad Request'
  text:  'Cannot not process the request due to an apparent client error.'

class Unauthorized
  status: 401
  title: 'Unauthorized'
  text:  'User does not have the necessary credentials.'

class Forbidden
  status: 401
  title: 'Forbidden'
  text:  'User does not have the necessary permissions for the resource.'

class NotFound
  status: 401
  title: 'Not Found'
  text:  'The requested resource could not be found.'

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.BadRequest   = BadRequest
module.exports.Unauthorized = Unauthorized
module.exports.Forbidden    = Forbidden
module.exports.NotFound     = NotFound

#-------------------------------------------------------------------------------