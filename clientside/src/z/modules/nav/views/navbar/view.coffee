#--------------------------------------------------------------------------------
# Imports
#--------------------------------------------------------------------------------

_            = require 'lodash'
$            = require 'jquery'
Backbone     = require 'backbone'
Radio        = require 'backbone.radio'
Marionette   = require 'marionette'
App          = require 'client/webapp'
viewTemplate = require './view.jade'

#--------------------------------------------------------------------------------
# View
#--------------------------------------------------------------------------------

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

  # Elements are not ready until onShow.

  onShow: ->

    # Create menu.
    $("#my-menu").mmenu
      offCanvas:
        zposition: "front"
      onClick:
        close: false
      header: true,
      footer:
        add: true,
        content: "(c) 2015 WebApp. All rights reserved"

    @ui.home.on 'click', =>
      @home()
      return

    @ui.profile.on 'click', =>
      @profile()
      return

    @ui.contacts.on 'click', =>
      @contacts()
      return

    @ui.movies.on 'click', =>
      @movies()
      return

    @ui.movie.on 'click', =>
      @movie()
      return

    @ui.chat.on 'click', =>
      @chat()
      return

    return
  events:

    #Open menu.
    'click @ui.brand': (event)->
      # Prevent change where a change is added to url.
      event.preventDefault();
      $("#my-menu").trigger("open.mm")
      return


    # XXX Events here are not working.
    # Fallback to listening from onShow() method instead.
    'click @ui.home':     'home'
    'click @ui.profile':  'profile'
    'click @ui.contacts': 'contacts'
    'click @ui.movies':   'movies'
    'click @ui.chat':     'chat'

    'click @ui.collapseItem': (event) ->
      @ui.collapseBtn.collapse('hide')
      #@ui.collapseBtn.collapse('hide') unless $(event.target).hasClass('dropdown-toggle')

      return

  'home' : ->
    Radio.command 'main', 'app:user:home'
    return

  'profile' : ->
    Radio.command 'main', 'app:user:profile'
    return

  'contacts' : ->
    Radio.command 'main', 'app:user:contacts'
    return

  'movies' : ->
    Radio.command 'main', 'app:user:movies'
    return

  'movie' : ->
    Radio.command 'main', 'app:user:movie' , 'test'
    return

  'chat' : ->
    Radio.command 'main', 'app:user:chatbox'
    return

#--------------------------------------------------------------------------------
# Exports
#--------------------------------------------------------------------------------

module.exports = View

#--------------------------------------------------------------------------------