#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

$            = require 'jquery'
_            = require 'lodash'
Backbone     = require 'backbone'
Radio        = require 'backbone.radio'
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

    home:     '#shortcut-home'
    strength: '#shortcut-strength'
    logs:     '#shortcut-logs'
    summary:  '#shortcut-summary'
    profile:  '.shortcut-profile'
    setting:  '.shortcut-setting'
    help:     '.shortcut-help'
    report:   '.shortcut-report'
    signout:  '.shortcut-signout'

  events:

    'click @ui.home': ->
      @channel.request 'home'
      return

    'click @ui.strength': ->
      @channel.request 'strength'
      return

    'click @ui.logs': ->
      @channel.request 'log'
      return

    'click @ui.summary': ->
      @channel.request 'stat'
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