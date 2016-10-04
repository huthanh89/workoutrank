#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_         = require 'lodash'
async     = require 'async'
moment    = require 'moment'
mongoose  = require 'mongoose'
crypto    = require 'crypto'

#-------------------------------------------------------------------------------
# Schema
#-------------------------------------------------------------------------------

FacebookSchema = new mongoose.Schema
  facebookID:
    type:   String
    unique: false
  name:
    type:   String
    unique: false
  accessToken:
    type:   String
    unique: false
  refreshToken:
    type:   String
    unique: false
,
  collection: 'facebook'

#-------------------------------------------------------------------------------
# Model Registration
#-------------------------------------------------------------------------------

model = mongoose.model('facebook', FacebookSchema)

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = model

#-------------------------------------------------------------------------------