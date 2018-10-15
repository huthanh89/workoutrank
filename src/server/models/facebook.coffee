#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_         = require 'lodash'
async     = require 'async'
moment    = require 'moment'
mongoose  = require 'mongoose'
crypto    = require 'crypto'

#-------------------------------------------------------------------------------
# Facebook Schema
#-------------------------------------------------------------------------------

schema = mongoose.Schema
  facebookID:
    type:   String
    unique: true
  name:
    type:   String
  accessToken:
    type:   String
  refreshToken:
    type:   String
,
  collection: 'facebook'

#-------------------------------------------------------------------------------
# Model Registration
#   In order to call 'Facebook' model from mongoose object.
#-------------------------------------------------------------------------------

model = mongoose.model('facebook', schema)

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = model

#-------------------------------------------------------------------------------