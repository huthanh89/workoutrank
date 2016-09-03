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
  auth:
    type: Number
    required: true
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
  height:
    type: Number
  weight:
    type: Number
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
# Methods
#-------------------------------------------------------------------------------

# Return public fields only.

UserSchema.methods.getPublicFields = ->
  return {
    _id:       @_id
    email:     @email
    username:  @username
    firstname: @firstname
    lastname:  @lastname
    height:    @height
    weight:    @weight
    gender:    @gender
    auth:      @auth
  }

#-------------------------------------------------------------------------------
# Model Registration
#-------------------------------------------------------------------------------

model = mongoose.model('user', UserSchema)

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = model

#-------------------------------------------------------------------------------