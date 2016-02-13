#--------------------------------------------------------------------------------
# Imports
#--------------------------------------------------------------------------------

Backbone   = require 'backbone'
Radio      = require 'backbone.radio'
Marionette = require 'marionette'
App        = require '../../webapp'
Controller = require './controller'

#--------------------------------------------------------------------------------
# Router
#--------------------------------------------------------------------------------

App.module 'webapp.user', () ->

  main = Radio.channel 'main'

  main.reply

    'app:user:home': ->
      console.log 'here'
      Controller.home()
      return

    'app:user:movies': ->
      Controller.movies()
      return

    'app:user:movie': (title) ->
      Controller.movie(title)
      return

  console.log 'webapp user'

  App.on 'before:start', ->

    App.addRegions
      mainRegion: '#content'

    console.log 'creating router'

    # initialize the router

    new Marionette.AppRouter
      controller: Controller
      appRoutes:
        '':              'home'
        'home':          'home'
        'contacts':      'contacts'
        'profile':       'profile'
        'movies':        'movies'
        'movies/:title': 'movie'
        'chatbox':       'chatbox'


#--------------------------------------------------------------------------------