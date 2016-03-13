#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_        = require 'lodash'
async    = require 'async'
mongoose = require 'mongoose'

#-------------------------------------------------------------------------------
# Models
#-------------------------------------------------------------------------------

Exercise = mongoose.model('exercise')
Strength = mongoose.model('strength')

#-------------------------------------------------------------------------------
# Log Get
#   Get a list all logs of a certain exercise.
#-------------------------------------------------------------------------------

module.logGet = (req, res, next) ->

  async.waterfall [

    (callback) ->

      Exercise.find()
      .lean()
      .exec (err, exercises) ->
        console.log 'ERROR', err if err
        return callback null, exercises[0].strength

      return

    (strengths, callback) ->

      # Find a certain exercise.

      strength = _.find strengths, (strength) ->
        return strength._id.toString() is req.params.sid

      return callback null, strength

    (strength, callback) ->

      # Get logs

      Strength.find
        exercise: req.params.sid
      .sort 'date'
      .lean()
      .exec (err, exercises) ->
        console.log 'ERROR', err if err
        return callback null, strength, exercises

      return

  ], (err, strength, exercises) ->

    console.log 'ERROR', err if err

    result = _.chain {}
      .extend strength
      .extend session: exercises
      .value()

    return res.json result

#-------------------------------------------------------------------------------
# Get
#   Get one exercise with given strengthID
#-------------------------------------------------------------------------------

module.get = (req, res, next) ->

  async.waterfall [

    (callback) ->

      Exercise.find()
      .exec (err, exercises) ->
        console.log 'ERROR', err if err
        return callback null, exercises[0].strength

      return

    (strengths, callback) ->

      strength = _.find strengths, (strength) ->
        return strength._id.toString() is req.params.sid

      return callback null, strength

  ], (err, documents) ->

    console.log 'ERROR', err if err

    return res.json documents

#-------------------------------------------------------------------------------
# Post
#   Create a new strength log.
#-------------------------------------------------------------------------------

module.post = (req, res) ->

  async.waterfall [

    (callback) ->

      Strength.create
        date:     req.body.date
        name:     req.body.name
        muscle:   req.body.muscle
        exercise: req.body.exercise
        note:     req.body.note
        session:  req.body.session
      , (err, result) ->
        return callback err if err
        return callback null, result

  ], (err, result) ->

    console.log err if err

    res
    .status 201
    .json result

    return

  return

#-------------------------------------------------------------------------------
# Put
#   Edit a new strength log.
#-------------------------------------------------------------------------------

module.put = (req, res, next) ->

  async.waterfall [

    (callback) ->

      Strength.findById req.params.sid, (err, strength) ->
        console.log 'ERROR', err if err
        return callback null, strength

      return

    (strength, callback) ->

      strength.date    = req.body.date
      strength.muscle  = req.body.muscle
      strength.name    = req.body.name
      strength.note    = req.body.note
      strength.session = req.body.session

      strength.save (err, strength) ->
        console.log 'ERROR', err if err
        return callback null, strength

      return

  ], (err, document) ->

    console.log 'ERROR', err if err

    return res.json document

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = module

#-------------------------------------------------------------------------------