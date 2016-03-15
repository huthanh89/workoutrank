#----------------------------------------------------------
# IMPORTS
#----------------------------------------------------------

async    = require 'async'
mongoose = require('mongoose')

#----------------------------------------------------------
# MODELS
#----------------------------------------------------------

Comment = mongoose.model('comment')

#----------------------------------------------------------
# GET
#----------------------------------------------------------

exports.get = (req, res) ->

  async.waterfall [

    (callback) ->

      console.log req.query

      limit = req.query.per_page
      page = req.query.page
      skip = (page - 1) * limit

      Comment
      .find()
      .sort
        date: -1
      .limit 10
      .skip  req.query.skip
      .lean  true
      .exec (err, comments) ->
        return callback null, comments

  ], (err, result) ->

    res.json result

    return

  return

#----------------------------------------------------------
# POST
#----------------------------------------------------------

exports.post = (req, res) ->

  console.log 'BODY', req.body

  comment =
    date:     new Date
    username: req.body.username
    comment:  req.body.comment

  Comment.create comment

  res
  .status 201
  .json comment

  return

#----------------------------------------------------------