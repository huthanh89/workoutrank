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

    home:        '.nav-home'
    strengths:   '.nav-strengths'
    logs:        '.nav-logs'
    summary:     '.nav-summary'
    account:     '.nav-account'
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
      observe: 'username'
      onGet: (value) -> value.toString().toUpperCase()

  events:

    'click #navbar-logo': ->
      Radio.channel('root').request 'drawer:close'
      @channel.request 'home'
      return

    'click #navbar-banner': ->
      Radio.channel('root').request 'drawer:close'
      @channel.request 'home'
      return

    'click #navbar-drawer': ->
      Radio.channel('root').request 'drawer:open'
      return

    'click @ui.strengths': ->
      Radio.channel('root').request 'drawer:close'
      @channel.request 'strengths'
      return

    'click @ui.logs': ->
      Radio.channel('root').request 'drawer:close'
      @channel.request 'logs'
      return

    'click @ui.account': ->
      Radio.channel('root').request 'drawer:close'
      @channel.request 'account'
      return

    'click @ui.setting': ->
      Radio.channel('root').request 'drawer:close'
      @channel.request 'setting'
      return

    'click @ui.about': ->
      Radio.channel('root').request 'drawer:close'
      @channel.request 'help'
      return

    'click @ui.report': ->
      Radio.channel('root').request 'drawer:close'
      @channel.request 'report'
      return

    'click @ui.logout': ->
      Radio.channel('root').request 'drawer:close'
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
      title:     'Journals'
      placement: 'bottom'

    @ui.logTip.tooltip
      title:     'Graphs'
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