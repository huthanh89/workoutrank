#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_         = require 'lodash'
async     = require 'async'
moment    = require 'moment'
mongoose  = require 'mongoose'
crypto    = require 'crypto'
Validate  = require '../routers/validate'

#-------------------------------------------------------------------------------
# Sanitize given string
#-------------------------------------------------------------------------------

sanitize = (string) -> string.trim().toLowerCase().replace(' ', '')

#-------------------------------------------------------------------------------
# Schema
#-------------------------------------------------------------------------------

UserSchema = new mongoose.Schema

  algorithm:
    type: String
  rounds:
    type: Number
  salt:
    type: String
  key:
    type: String
  email:
    type:   String
  username:
    type:   String

  facebookID:
    type:   String

  twitterID:
    type:   String

  googleID:
    type:   String

  provider:
    type: String

  created:
    type: Date
  auth:
    type: Number
  lastlogin:
    type: Date
  firstname:
    type: String
  lastname:
    type: String
  birthday:
    type: Date
  height:
    type: Number
  weight:
    type: Number
  gender:
    type: Number
  displayName:
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
    birthday:  @birthday
    lastlogin: @lastlogin
    provider:  @provider
  }

UserSchema.methods.validPassword = (password, callback) ->
  crypto.pbkdf2 password, @salt, @rounds, 32, @algorithm, (err, key) =>
    if @key is key.toString('hex')
      return callback null, @_id
    else
      return callback null, false, message: 'Incorrect password.'
    return
  return

#-------------------------------------------------------------------------------
# Model Registration
#-------------------------------------------------------------------------------

model = mongoose.model('user', UserSchema)

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = model

#-------------------------------------------------------------------------------