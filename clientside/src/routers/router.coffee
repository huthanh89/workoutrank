#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_          = require 'lodash'
Backbone   = require 'backbone'
Marionette = require 'marionette'
IndexView  = require './views/index/view'

#-------------------------------------------------------------------------------
# Router
#-------------------------------------------------------------------------------

class Router extends Marionette.AppRouter

  rootChannel = Backbone.Radio.channel('root')

  routes:
    '':     'index'
    'home': 'home'

  home: ->
    console.log 'home'
    return

  index: ->
    rootView = rootChannel.request('rootview')
    rootView.content.show(new IndexView())
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = Router

#-------------------------------------------------------------------------------
