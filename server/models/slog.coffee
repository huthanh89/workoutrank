#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

mongoose = require 'mongoose'

#-------------------------------------------------------------------------------
# Schema
#-------------------------------------------------------------------------------

SlogSchema = new mongoose.Schema
  date:
    type: Date
    required: true
  note:
    type: String
  rep:
    type: Number
    required: true
  weight:
    type: Number
    required: true
  exercise:
    type: mongoose.Schema.ObjectId
    required: true
  user:
    type: mongoose.Schema.ObjectId
    required: true
,
  collection: 'slog'

#-------------------------------------------------------------------------------
# Model Registration
#-------------------------------------------------------------------------------

model = mongoose.model('slog', SlogSchema)

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = model

#-------------------------------------------------------------------------------