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
    home:     '#nav-home'
    strength: '#nav-strength'
    log:      '#nav-log'
    stat:     '#nav-stat'
    profile:  '#nav-profile'
    setting:  '#nav-setting'
    about:    '#nav-about'
    report:   '#nav-report'
    logout:   '#nav-logout'

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

    'click @ui.log': ->
      @channel.request 'log'
      return

    'click @ui.stat': ->
      @channel.request 'stat'
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

    @ui.home.tooltip
      title:     'Home'
      placement: 'bottom'

    @ui.strength.tooltip
      title:     'Workout'
      placement: 'bottom'

    @ui.log.tooltip
      title:     'Logs'
      placement: 'bottom'

    @ui.stat.tooltip
      title:     'Stats'
      placement: 'bottom'

    @stickit()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------