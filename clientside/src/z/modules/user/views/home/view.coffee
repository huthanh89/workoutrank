#--------------------------------------------------------------------------------
# Imports
#--------------------------------------------------------------------------------

_            = require 'lodash'
$            = require 'jquery'
Marionette   = require 'marionette'
viewTemplate = require './view.jade'

#--------------------------------------------------------------------------------
# View
#--------------------------------------------------------------------------------

class View extends Marionette.ItemView
  template: viewTemplate
  initialize: ->

    socket = require('socket.io')()


    console.log socket

    socket.on 'tweets', (data) ->
      console.log data

    socket.on 'tweetError', (data) ->
      console.log data

    return
#--------------------------------------------------------------------------------
# Exports
#--------------------------------------------------------------------------------

module.exports = View

#--------------------------------------------------------------------------------