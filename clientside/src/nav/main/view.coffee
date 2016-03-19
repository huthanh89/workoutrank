#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
$            = require 'jquery'
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
    brand:    '#navbar-brand'

    home:        '.nav-home'
    strength:    '.nav-strength'
    log:         '.nav-log'
    stat:        '.nav-stat'

    homeTip:     '.nav-home-tip'
    strengthTip: '.nav-strength-tip'
    logTip:      '.nav-log-tip'
    statTip:     '.nav-stat-tip'

    profile:     '.nav-profile'
    contacts:    '.nav-contacts'
    exercise:    '.nav-exercise'
    menu:        '#my-menu'

  bindings:
    '#nav-username':
      observe: 'firstname'
      onGet: (value) -> value.toString().toUpperCase()

  events:

    #Open menu.

    'click @ui.brand': (event)->
      # Prevent change where a change is added to url.
      event.preventDefault()
      $("#my-menu").trigger("open.mm")
      return

    'click @ui.home': ->
      @channel.request 'home'
      return

    'click @ui.strength': ->
      @channel.request 'strength'
      return

  constructor: ->
    super
    @channel = Backbone.Radio.channel('root')

  onRender: ->

    @ui.homeTip.tooltip
      title:     'Home'
      placement: 'bottom'

    @ui.strengthTip.tooltip
      title:     'Workout'
      placement: 'bottom'

    @ui.logTip.tooltip
      title:     'Logs'
      placement: 'bottom'

    @ui.statTip.tooltip
      title:     'Stats'
      placement: 'bottom'

    @stickit()
    return

  # Elements are not ready until onShow.

  onShow: ->

    # Create menu.

    @ui.menu.mmenu
      offCanvas:
        zposition: "front"
      onClick:
        close: false
      header: true,
      footer:
        add: true,
        content: "(c) 2015 WebApp. All rights reserved"

    @ui.profile.on 'click', =>
      @channel.request('profile')
      return

    @ui.contacts.on 'click', =>
      @channel.request('home')
      return

    @ui.exercise.on 'click', =>
      @channel.request('exercise')
      return

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------