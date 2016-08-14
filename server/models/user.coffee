#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

mongoose = require 'mongoose'

#-------------------------------------------------------------------------------
# Schema
#-------------------------------------------------------------------------------

UserSchema = new mongoose.Schema
  created:
    type: Date
  lastlogin:
    type: Date
  firstname:
    type: String
  lastname:
    type: String
  email:
    type:     String
    unique:   true
    required: true
    index: true
  username:
    type:     String
    unique:   true
    required: true
    index: true
  birthday:
    type: Date
    required: true
  gender:
    type: Number
  algorithm:
    type: String
  rounds:
    type: Number
  salt:
    type: String
  key:
    type: String
,
  collection: 'user'

#-------------------------------------------------------------------------------
# Model Registration
#-------------------------------------------------------------------------------

model = mongoose.model('user', UserSchema)

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = model

#-------------------------------------------------------------------------------