#--------------------------------------------------------------------------------
# Imports
#--------------------------------------------------------------------------------

_            = require 'lodash'
$            = require 'jquery'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
App          = require 'client/webapp'
ContactsView = require './views/contacts/view'
HomeView     = require './views/home/view'
ProfileView  = require './views/profile/view'
ChatView     = require './views/chat/view'
Movies   = require './views/movies/module'

#--------------------------------------------------------------------------------
# Controller
#--------------------------------------------------------------------------------

Controller =

  contacts: ->
    Backbone.history.navigate 'contacts'
    App.mainRegion.show new ContactsView()
    return

  home: ->
    console.log 'home'
    Backbone.history.navigate 'home'
    App.mainRegion.show new HomeView()
    return

  profile: ->
    Backbone.history.navigate 'profile'
    App.mainRegion.show new ChatView()
    return

  movies: ->
    Backbone.history.navigate 'movies'
    App.mainRegion.show new Movies.MasterView()
    return

  movie: (title) ->
    console.log 'here ->', title
    Backbone.history.navigate 'movies/' + title
    App.mainRegion.show new Movies.DetailView
      title: title
    return

  chatbox: ->
    console.log 'api chat'
    Backbone.history.navigate 'chatbox'
    App.mainRegion.show new ChatView()
    return

#--------------------------------------------------------------------------------
# Exports
#--------------------------------------------------------------------------------

module.exports = Controller

#--------------------------------------------------------------------------------