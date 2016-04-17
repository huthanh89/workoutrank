#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

$            = require 'jquery'
_            = require 'lodash'
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

    home:        '.nav-home'
    strengths:   '.nav-strengths'
    logs:        '.nav-logs'
    summary:     '.nav-summary'
    profile:     '.nav-profile'
    setting:     '.nav-setting'
    about:       '.nav-about'
    report:      '.nav-report'
    logout:      '.nav-logout'

    homeTip:     '.nav-home-tip'
    strengthTip: '.nav-strengths-tip'
    logTip:      '.nav-logs-tip'
    summaryTip:  '.nav-summary-tip'

  bindings:
    '#nav-username':
      observe: 'firstname'
      onGet: (value) -> value.toString().toUpperCase()

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

    'click @ui.about': ->
      @channel.request 'help'
      return

    'click @ui.report': ->
      @channel.request 'report'
      return

    'click @ui.logout': ->
      @channel.request 'logout'
      return

  constructor: ->
    super
    @channel = Backbone.Radio.channel('root')

  onRender: ->

    @ui.homeTip.tooltip
      title:     'Home'
      placement: 'bottom'

    @ui.strengthTip.tooltip
      title:     'Workouts'
      placement: 'bottom'

    @ui.logTip.tooltip
      title:     'Logs'
      placement: 'bottom'

    @ui.summaryTip.tooltip
      title:     'Summary'
      placement: 'bottom'

    @stickit()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------