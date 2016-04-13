#-------------------------------------------------------------------------------
# Base Error class
#-------------------------------------------------------------------------------

class Err extends Error

  constructor: (options) ->
    super
    if options?.text
      @text = options.text

#-------------------------------------------------------------------------------
# HTTP Response code
#-------------------------------------------------------------------------------

class BadRequest extends Err
  status: 400
  title: 'Bad Request'
  text:  'Cannot not process the request due to an apparent client error.'

class Unauthorized extends Err
  status: 401
  title: 'Unauthorized'
  text:  'User does not have the necessary credentials.'

class Forbidden extends Err
  status: 403
  title: 'Forbidden'
  text:  'User does not have the necessary permissions for the resource.'

class NotFound extends Err
  status: 404
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