#--------------------------------------------------------------------------------
# Imports
#--------------------------------------------------------------------------------

App        = require '../../webapp'
NavView    = require './views/navbar/view'
Marionette = require 'marionette'

#--------------------------------------------------------------------------------

App.module 'webapp.nav', () ->

  App.on 'before:start', ->

    App.addRegions
      headerRegion: '#header'

    App.headerRegion.show(new NavView())

#--------------------------------------------------------------------------------