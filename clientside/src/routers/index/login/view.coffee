#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Backbone     = require 'backbone'
Marionette   = require 'marionette'
Login        = require './login/module'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  regions:
    login: '#login-view'

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')
    @channel = Backbone.Radio.channel('channel')

  onShow: ->
    @showChildView 'login', new Login.View
      model:   new Login.Model()
      channel: @channel
    return

  onDestroy: ->
    @channel.reset()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
