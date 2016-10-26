#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

mongoose = require 'mongoose'

#-------------------------------------------------------------------------------
# CLog Schema
#-------------------------------------------------------------------------------

schema = mongoose.Schema
  created:
    type: Date
    required: true
  note:
    type: String
  intensity:
    type: Number
  speed:
    type: Number
  startDate:
    type: Date
    required: true
  endDate:
    type: Date
    required: true
  exerciseID:
    type: mongoose.Schema.ObjectId
    required: true
  user:
    type: mongoose.Schema.ObjectId
    required: true
,
  collection: 'clog'

#-------------------------------------------------------------------------------
# Model Registration
#-------------------------------------------------------------------------------

model = mongoose.model('clog', schema)

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = model

#-------------------------------------------------------------------------------