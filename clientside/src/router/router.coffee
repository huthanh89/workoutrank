#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_           = require 'lodash'
Backbone    = require 'backbone'
Marionette  = require 'marionette'
IndexView   = require './views/index/view'
Profile     = require './views/profile/module'

#-------------------------------------------------------------------------------
# Router
#-------------------------------------------------------------------------------

class Router extends Marionette.AppRouter

  constructor: ->

    super

    rootChannel = Backbone.Radio.channel('root')
    @rootView   = rootChannel.request('rootview')

    # Replies for menu navigation.

    rootChannel.reply
      index: =>
        @index()
        return
      home: =>
        @home()
        return
      profile: =>
        @profile()
        return

  # Routes used for backbone urls.

  routes:
    '':        'index'
    'home':    'home'
    'profile': 'profile'

  # Show Views

  index: ->
    @rootView.content.show(new IndexView())
    @navigate('')
    return

  home: ->
    @navigate('home')
    @rootView.content.show(new IndexView())
    return

  profile: ->
    @navigate('profile')

    collection = new Profile.Collection()

    console.log 'fetching'

    collection.fetch
      success: (collection) ->
        console.log 'done', collection
        return
      error: ->
        console.log 'error'
        return

    @rootView.content.show(new Profile.View())
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = Router

#-------------------------------------------------------------------------------
