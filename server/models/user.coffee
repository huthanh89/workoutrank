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
    type: String
    index:
      unique: true
  username:
    type: String
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