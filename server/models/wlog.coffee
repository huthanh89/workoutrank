#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

mongoose = require 'mongoose'

#-------------------------------------------------------------------------------
# Schema
#-------------------------------------------------------------------------------

WLogSchema = new mongoose.Schema
  date:
    type: Date
    required: true
  weight:
    type: Number
    required: true
  user:
    type: mongoose.Schema.ObjectId
    required: true
  note:
    type: String
,
  collection: 'wlog'

#-------------------------------------------------------------------------------
# Model Registration
#-------------------------------------------------------------------------------

model = mongoose.model('wlog', WLogSchema)

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = model

#-------------------------------------------------------------------------------