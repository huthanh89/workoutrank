#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Radio        = require 'backbone.radio'
Marionette   = require 'backbone.marionette'
viewTemplate = require './view.pug'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'backbone.stickit'

#-------------------------------------------------------------------------------
# Channels
#-------------------------------------------------------------------------------

rootChannel = Radio.channel('root')

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
      rootChannel.request 'drawer:close'
      rootChannel.request 'home'
      return

    'click #navbar-banner': ->
      rootChannel.request 'drawer:close'
      rootChannel.request 'home'
      return

    'click #navbar-drawer': ->
      rootChannel.request 'drawer:open'
      return

    'click @ui.strengths': ->
      rootChannel.request 'drawer:close'
      rootChannel.request 'strengths'
      return

    'click @ui.cardios': ->
      rootChannel.request 'drawer:close'
      rootChannel.request 'cardios'
      return

    'click @ui.account': ->
      rootChannel.request 'drawer:close'
      rootChannel.request 'account'
      return

    'click @ui.profile': ->
      rootChannel.request 'drawer:close'
      rootChannel.request 'profile'
      return

    'click @ui.logout': ->
      rootChannel.request 'drawer:close'
      rootChannel.request 'logout'
      return

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