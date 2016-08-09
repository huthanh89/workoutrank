#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_         = require 'lodash'
validator = require 'validator'

#-------------------------------------------------------------------------------
# Types of methods available to validate.
#-------------------------------------------------------------------------------

Methods = [
  { method: 'isBoolean', text: 'not a boolean format'   }
  { method: 'isDate',    text: 'not a date format'      }
  { method: 'isFloat',   text: 'not a decimal number'   }
  { method: 'isInt',     text: 'not a number'           }
  { method: 'isEmail',   text: 'incorrect email format' }
  { method: 'isLength',  text: 'incorrect length'       }
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

    # Return false if req body is not in schema to validate.

    methods = schema[bodyKey]

    # If key is is unknown, then just skip validation on it.

    return callback(null) unless methods

    # Sanitize input before proceeding.

    if typeof bodyValue is 'string'
      requestBody[bodyKey] = bodyValue = sanitize(bodyValue)
    else
      bodyValue = bodyValue.toString()

    for obj in methods

      passed = validator[obj.method](bodyValue, obj.options)

      if not passed
        return callback "#{bodyKey} - #{_.find(Methods, method: obj.method).text}."

  return callback(null)

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.isValid = isValid

#-------------------------------------------------------------------------------