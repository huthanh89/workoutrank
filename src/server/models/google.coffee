#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

mongoose  = require 'mongoose'

#-------------------------------------------------------------------------------
# Google Schema
#-------------------------------------------------------------------------------

schema = mongoose.Schema
  googleID:
    type:   String
    unique: true
  accessToken:
    type:   String
  refreshToken:
    type:   String
,
  collection: 'google'

#-------------------------------------------------------------------------------
# Model Registration
#-------------------------------------------------------------------------------

model = mongoose.model('google', schema)

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = model

#-------------------------------------------------------------------------------