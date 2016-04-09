#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Backbone     = require 'backbone'
Marionette   = require 'marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:

    home:      '#shortcut-home'
    strengths: '#shortcut-strengths'
    logs:      '#shortcut-logs'
    summary:   '#shortcut-summary'

  events:

    'click @ui.home': ->
      @channel.request 'home'
      return

    'click @ui.strengths': ->
      @channel.request 'strengths'
      return

    'click @ui.logs': ->
      @channel.request 'logs'
      return

    'click @ui.summary': ->
      @channel.request 'summary'
      return

    'click @ui.profile': ->
      @channel.request 'profile'
      return

    'click @ui.setting': ->
      @channel.request 'setting'
      return

    'click @ui.help': ->
      @channel.request 'help'
      return

    'click @ui.report': ->
      @channel.request 'report'
      return

    'click @ui.signout': ->
      @channel.request 'signout'
      return

  constructor: ->
    super
    @channel = Backbone.Radio.channel('root')

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------