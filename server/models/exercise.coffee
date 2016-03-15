#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

mongoose = require 'mongoose'

#-------------------------------------------------------------------------------
# Schema
#-------------------------------------------------------------------------------

ExerciseSchema = new mongoose.Schema
  user:
    type: mongoose.Schema.ObjectId
  strength: [
    date:
      type: Date
    name:
      type: String
    muscle:
      type: Number
    note:
      type: String
  ]
,
  collection: 'exercise'

#-------------------------------------------------------------------------------
# Model Registration
#-------------------------------------------------------------------------------

model = mongoose.model('exercise', ExerciseSchema)

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = model

#-------------------------------------------------------------------------------