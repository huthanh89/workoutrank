#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

mongoose = require 'mongoose'

#-------------------------------------------------------------------------------
# CLog Schema
#-------------------------------------------------------------------------------

schema = mongoose.Schema
  date:
    type: Date
    required: true
  note:
    type: String
  intensity:
    type: Number
    required: true
  start:
    type: Date
    required: true
  end:
    type: Date
    required: true
  cardio:
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