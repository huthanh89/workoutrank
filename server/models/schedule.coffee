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
    required: true
  monday:
    type: [Number]
    required: true
  tuesday:
    type: [Number]
    required: true
  wednesday:
    type: [Number]
    required: true
  thursday:
    type: [Number]
    required: true
  friday:
    type: [Number]
    required: true
  saturday:
    type: [Number]
    required: true
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