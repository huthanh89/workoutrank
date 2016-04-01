#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

mongoose = require 'mongoose'

#-------------------------------------------------------------------------------
# Schema  XXX Not yet implemented
#-------------------------------------------------------------------------------

ExerciseSchema = new mongoose.Schema
  workouts:[
    date:
      type: Date
    name:
      type: String
    rep:
      type: Number
    weight:
      type: Number
  ]
    type: Array
  cardios:[
    date:
      type: Date
    name:
      type: String
    duration:
      type: Number
  ]
  weights:[
    date:
      type: Date
    pound:
      type: String
  ]

,
  collection: 'log'

#-------------------------------------------------------------------------------
# Model Registration
#-------------------------------------------------------------------------------

model = mongoose.model('log', ExerciseSchema)

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = model

#-------------------------------------------------------------------------------