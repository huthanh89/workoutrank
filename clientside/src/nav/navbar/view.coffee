#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

$            = require 'jquery'
_            = require 'lodash'
Backbone     = require 'backbone'
Radio        = require 'backbone.radio'
Marionette   = require 'backbone.marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'backbone.stickit'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.View

  template: viewTemplate

  ui:

    home:         '.nav-home'
    strengths:    '.nav-strengths'
    cardios:      '.nav-cardios'
    summary:      '.nav-summary'
    profile:      '.nav-profile'
    account:      '.nav-account'
    setting:      '.nav-setting'
    about:        '.nav-about'
    report:       '.nav-report'
    logout:       '.nav-logout'
    strengthsTip: '.nav-strengths-tip'
    cardiosTip:   '.nav-cardios-tip'

  bindings:
    '#nav-username':
      observe: 'username'

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

    'click @ui.cardios': ->
      Radio.channel('root').request 'drawer:close'
      @channel.request 'cardios'
      return

    'click @ui.account': ->
      Radio.channel('root').request 'drawer:close'
      @channel.request 'account'
      return

    'click @ui.profile': ->
      Radio.channel('root').request 'drawer:close'
      @channel.request 'profile'
      return

    'click @ui.logout': ->
      Radio.channel('root').request 'drawer:close'
      @channel.request 'logout'
      return

  constructor: ->
    super
    @channel = Backbone.Radio.channel('root')

  onRender: ->

    @ui.strengthsTip.tooltip
      title:     'Strength'
      placement: 'bottom'

    @ui.cardiosTip.tooltip
      title:     'Cardio'
      placement: 'bottom'

    @stickit()
    return

  onBeforeDestroy: ->
    @unstickit()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------