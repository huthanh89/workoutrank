#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

mongoose = require 'mongoose'

#-------------------------------------------------------------------------------
# Feedback Schema
#-------------------------------------------------------------------------------

schema = mongoose.Schema
  date:
    type: Date
  type:
    type: Number
  title:
    type: String
  text:
    type: String
,
  collection: 'feedback'

#-------------------------------------------------------------------------------
# Model Registration
#-------------------------------------------------------------------------------

model = mongoose.model('feedback', schema)

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = model

#-------------------------------------------------------------------------------