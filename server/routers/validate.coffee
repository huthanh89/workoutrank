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
  { type: 'date',   method: 'isDate'   }
  { type: 'float',  method: 'isFloat'  }
  { type: 'int',    method: 'isInt'    }
  { type: 'email',  method: 'isEmail'  }
  { type: 'length', method: 'isLength' }
]

#-------------------------------------------------------------------------------
# Validate request
#-------------------------------------------------------------------------------

isValid = (req, schema, callback) ->

  for key, value of req

    # Return false if req body is not in schema to validate.

    field = schema[key]

    if field is undefined
      return callback new Err.BadRequest
        text: "Not acceptable field: #{key}"


    # Return null if there is nothing to test.

    return callback(null) if field.type in ['string']

    # Return false if failed validator test.

    method = _.find(Methods, type: field.type).method

    if validator[method](value) is false
      return callback new Err.BadRequest
        status:  408
        text:   "Invalid field: #{key}"

  return callback(null)

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.isValid = isValid

#-------------------------------------------------------------------------------