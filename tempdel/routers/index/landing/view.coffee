#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Radio        = require 'backbone.radio'
Marionette   = require 'backbone.marionette'
viewTemplate = require './view.pug'

#-------------------------------------------------------------------------------
# Channels
#-------------------------------------------------------------------------------

rootChannel = Radio.channel('root')

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.View

  template: viewTemplate

  events:

    'click .index-signup-btn': ->
      rootChannel.request('signup')
      return

    'click .index-login-btn': ->
      rootChannel.request('login')
      return

    'click #index-google-play': ->
      window.open('https://play.google.com/store/apps/details?id=workoutrank.com.free&hl=en', '_blank')
      return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
