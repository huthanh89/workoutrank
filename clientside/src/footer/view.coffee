#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Radio        = require 'backbone.radio'
Marionette   = require 'backbone.marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'backbone.stickit'

#-------------------------------------------------------------------------------
# Channels
#-------------------------------------------------------------------------------

rootChannel = Radio.channel('root')
userChannel = Radio.channel('user')

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.View

  template: viewTemplate

  ui:
    'navigate': '#footer-navigate'

  bindings:
    '#footer-navigate':
      observe: 'lastlogin'
      visible: (value) -> value.length isnt 0

  events:

    'click #footer-about': ->
      rootChannel.request 'about'
      return

    'click #footer-feedback': ->
      rootChannel.request 'feedback'
      return

    'click #footer-home': ->
      rootChannel.request 'home'
      return

  onRender: ->
    user = userChannel.request 'user'
    @stickit user
    return

  onBeforeDestroy: ->
    @unstickit()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
