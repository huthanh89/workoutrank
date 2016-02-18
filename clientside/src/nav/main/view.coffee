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
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:
    brand:        '#navbar-brand'
    home:         '#nav-user-home'
    profile:      '#nav-user-profile'
    contacts:     '#nav-user-contacts'
    movies:       '#nav-user-movies'
    movie:        '#nav-user-movie'
    chat:         '#nav-user-chat'
    collapseItem: '.nav-collapse-item'
    collapseBtn:  '#nav-user-collapse-btn'
    menu:         '#my-menu'

  constructor: ->
    super
    @channel = Backbone.Radio.channel('root')

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

    @ui.home.on 'click', =>
      @channel.request('home')
      return

    @ui.profile.on 'click', =>
      @channel.request('profile')
      return

    @ui.contacts.on 'click', =>
      @channel.request('home')
      return

    @ui.movies.on 'click', =>
      @channel.request('home')
      return

    @ui.movie.on 'click', =>
      @channel.request('home')
      return

    @ui.chat.on 'click', =>
      @channel.request('home')
      return

    return

  events:

    #Open menu.

    'click @ui.brand': (event)->
      # Prevent change where a change is added to url.
      event.preventDefault()
      $("#my-menu").trigger("open.mm")
      return

    'click @ui.collapseItem': (event) ->
      @ui.collapseBtn.collapse('hide')
      #@ui.collapseBtn.collapse('hide') unless $(event.target)
      # .hasClass('dropdown-toggle')

      return

  'click @ui.home' : ->

    console.log 'here'

#    Radio.command 'main', 'app:user:home'
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------