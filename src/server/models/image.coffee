#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

async    = require 'async'
moment   = require 'moment'
mongoose = require 'mongoose'

#-------------------------------------------------------------------------------
# Image Schema
#-------------------------------------------------------------------------------

schema = mongoose.Schema
  uploadDate:
    type: Date
    required: true
  lastModified:
    type: Number
    required: true
  lastModifiedDate:
    type: Date
    required: true
  name:
    type: String
    required: true
  size:
    type: Number
    required: true
  imageType:
    type: String
    required: true
  type:
    type: String
    required: true
  data:
    type: String
    required: true
  user:
    type: mongoose.Schema.ObjectId
    required: true
,
  collection: 'image'

#-------------------------------------------------------------------------------
# Model Registration
#
# Now you can access model from mongoose object instead of need to require.
#-------------------------------------------------------------------------------

model = mongoose.model('image', schema)

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = model

#-------------------------------------------------------------------------------