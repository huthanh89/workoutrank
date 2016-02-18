#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment   = require 'moment'
async    = require 'async'
mongoose = require('mongoose')

#-------------------------------------------------------------------------------
# Models
#-------------------------------------------------------------------------------

User = mongoose.model('user')

#-------------------------------------------------------------------------------
# Post
#-------------------------------------------------------------------------------

exports.post = (req, res) ->

  async.waterfall [

    (callback) ->

      User.findOne
        email: 'admin'
      .exec (err, user) ->
        return callback err if err
        return callback null, user

      return

  ], (err, result) ->

    console.log 'error', err if err

    res
    .status 201
    .json result

  return


#-------------------------------------------------------------------------------