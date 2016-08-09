#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Err       = require './error'
_         = require 'lodash'
validator = require 'validator'

#-------------------------------------------------------------------------------
# Types of methods available to validate.
#-------------------------------------------------------------------------------

Methods = [
  { method: 'isDate',   text: 'not a date format'    }
  { method: 'isFloat',  text: 'not a decimal number' }
  { method: 'isInt',    text: 'not a number'         }
  { method: 'isEmail',  text: 'incorrect email format'     }
  { method: 'isLength', text: 'incorrect length'     }
]

#-------------------------------------------------------------------------------
# Sanitize given value
#-------------------------------------------------------------------------------

sanitize = (str) ->
  str = validator.blacklist(str, ['\\', '/', ' '])
  str = validator.escape(str)
  str = validator.trim(str)
  return str

#-------------------------------------------------------------------------------
# Validate request
#-------------------------------------------------------------------------------

isValid = (requestBody, schema, callback) ->

  for bodyKey, bodyValue of requestBody

    # Sanitize input before proceeding.

    requestBody[bodyKey] = bodyValue = sanitize(bodyValue)

    # Return false if req body is not in schema to validate.

    methods = schema[bodyKey]

    if methods is undefined
      return callback new Err.BadRequest
        text: "#{bodyKey} - is an unknown field and is not accepted"

    for obj in methods

      passed = validator[obj.method](bodyValue, obj.options)

      if not passed
        return callback new Err.BadRequest
          status:  408
          text:   "#{bodyKey} - #{_.find(Methods, method: obj.method).text}."

  return callback(null)

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.isValid = isValid

#-------------------------------------------------------------------------------