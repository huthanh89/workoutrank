#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Backbone     = require 'backbone'
Marionette   = require 'marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'backbone.stickit'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:
    'navigate': '#footer-navigate'

  bindings:
    '#footer-navigate':
      observe: 'lastlogin'
      visible: (value) -> value.length isnt 0

  events:

    'click #footer-about': ->
      @rootChannel.request 'about'
      return

    'click #footer-feedback': ->
      @rootChannel.request 'feedback'
      return

    'click #footer-home': ->
      @rootChannel.request 'home'
      return

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')
    @userChannel = Backbone.Radio.channel('user')

  onShow: ->
    user = @userChannel.request 'user'
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
