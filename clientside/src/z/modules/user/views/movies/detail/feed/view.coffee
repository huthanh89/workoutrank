#--------------------------------------------------------------------------------
# Imports
#--------------------------------------------------------------------------------

_            = require 'lodash'
$            = require 'jquery'
async        = require 'async'
Backbone     = require 'backbone'
Radio        = require 'backbone.radio'
Marionette   = require 'marionette'
ItemView     = require './item/view'
viewTemplate = require './view.jade'

#--------------------------------------------------------------------------------
# Model
#--------------------------------------------------------------------------------

class Model extends Backbone.Model
  idAttribute: '_id'
  url:         'api/chatbox'
  defaults:
    username:  'my username'
    comment:   ''
    date:      new Date()

#--------------------------------------------------------------------------------
# View
#--------------------------------------------------------------------------------

class View extends Marionette.CompositeView

  template: _.constant ''

  childView: ItemView

  initialize: ->

    console.log 'collection', @collection

    #@collection.add new Model username:'bob'
    #@collection.add new Model username:'bob1'
    #@collection.add new Model username:'bob2'

    socket = require('socket.io')()

    console.log socket

    socket.on 'tweets', (data) =>
      console.log data

      console.log '--->', data.user['profile_image_url_https']

      @collection.add new Model
        text: data.text
        created_at: data['created_at']
        profile_image_url_https: data.user['profile_image_url_https']
        screen_name: data.user['screen_name']
        name: name

    socket.on 'tweetError', (data) ->
      console.log data


  onShow: ->
    return

#--------------------------------------------------------------------------------
# Exports
#--------------------------------------------------------------------------------

module.exports = View

#--------------------------------------------------------------------------------