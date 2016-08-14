#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

mongoose = require 'mongoose'

#-------------------------------------------------------------------------------
# Schema
#-------------------------------------------------------------------------------

ScheduleSchema = new mongoose.Schema
  user:
    type: mongoose.Schema.ObjectId
    required: true
  date:
    type: Date
    required: true
  sunday:
    type: [Number]
  monday:
    type: [Number]
  tuesday:
    type: [Number]
  wednesday:
    type: [Number]
  thursday:
    type: [Number]
  friday:
    type: [Number]
  saturday:
    type: [Number]
,
  collection: 'schedule'

#-------------------------------------------------------------------------------
# Model Registration
#-------------------------------------------------------------------------------

model = mongoose.model('schedule', ScheduleSchema)

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = model

#-------------------------------------------------------------------------------