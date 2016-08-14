#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

mongoose = require 'mongoose'

#-------------------------------------------------------------------------------
# Schema
#-------------------------------------------------------------------------------

StrengthSchema = new mongoose.Schema
  user:
    type: mongoose.Schema.ObjectId
    required: true
  date:
    type: Date
    required: true
  name:
    type: String
    required: true
  muscle:
    type: Number
    required: true
  body:
    type: Boolean
    required: true
  note:
    type: String
,
  collection: 'strength'

#-------------------------------------------------------------------------------
# Model Registration
#-------------------------------------------------------------------------------

model = mongoose.model('strength', StrengthSchema)

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = model

#-------------------------------------------------------------------------------