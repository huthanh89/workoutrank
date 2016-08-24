#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_         = require 'lodash'
moment    = require 'moment'
async     = require 'async'
mongoose  = require 'mongoose'
Validate  = require '../../validate'

#-------------------------------------------------------------------------------
# Models
#-------------------------------------------------------------------------------

Feedback = mongoose.model('feedback')

#-------------------------------------------------------------------------------
# Sanitize given string
#-------------------------------------------------------------------------------

sanitize = (string) -> string.trim().toLowerCase().replace(' ', '')

#-------------------------------------------------------------------------------
# Post
#-------------------------------------------------------------------------------

schema =
  title: [
    method: 'isLength'
    options:
      min: 1
      max: 25
  ]
  text: [
    method: 'isLength'
    options:
      min: 1
      max: 200
  ]

exports.post = (req, res) ->

  async.waterfall [

    (callback) ->
      return Validate.isValid(req.body, schema, callback)

    (callback) ->

      Feedback.create
        date:  moment()
        title: sanitize req.body.title
        text:  sanitize req.body.text
        type:  0

      , (err, feedback) ->
        return callback err if err
        return callback null, feedback
      return

  ], (err, feedback) ->

    # Response error status and text.

    if err
      res
      .status 400
      .json   err

    else

      res
      .status 201
      .json feedback

  return

#-------------------------------------------------------------------------------
