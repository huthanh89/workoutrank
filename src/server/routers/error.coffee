#-------------------------------------------------------------------------------
# Base Error class
#-------------------------------------------------------------------------------

class Err extends Error

  constructor: (options) ->
    super(options)
    if options?.status
      @status = options.status
    if options?.statusText
      @statusText = options.statusText
    if options?.responseText
      @responseText = options.responseText

#-------------------------------------------------------------------------------
# HTTP Response code
#-------------------------------------------------------------------------------

class BadRequest extends Err
  status:        400
  statusText:   'Bad Request'
  responseText: 'Cannot not process the request due to an apparent client error.'

class Unauthorized extends Err
  status:        401
  statusText:   'Unauthorized'
  responseText: 'User does not have the necessary credentials.'

class Forbidden extends Err
  status:        403
  statusText:   'Forbidden'
  responseText: 'User does not have the necessary permissions for the resource.'

class NotFound extends Err
  status:        404
  statusText:   'Not Found'
  responseText: 'The requested resource could not be found.'

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.BadRequest   = BadRequest
module.exports.Unauthorized = Unauthorized
module.exports.Forbidden    = Forbidden
module.exports.NotFound     = NotFound

#-------------------------------------------------------------------------------