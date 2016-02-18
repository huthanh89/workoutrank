
#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Backbone   = require 'backbone'
Marionette = require 'marionette'
Nav        = require './nav/module'
Router     = require './router/router'

#-------------------------------------------------------------------------------
# RootView
#-------------------------------------------------------------------------------

class RootView extends Marionette.LayoutView
  el: 'body'
  regions:
    header:  '#header'
    content: '#content'

#-------------------------------------------------------------------------------
# Create Application.
#-------------------------------------------------------------------------------

class Application extends Marionette.Application

  onStart: ->

    rootView = new RootView()

    rootChannel = Backbone.Radio.channel('root')
    navChannel  = Backbone.Radio.channel('nav')

    rootChannel.reply
      'rootview': -> rootView

    navChannel.reply

      'nav:index': ->
        rootView.showChildView 'header', new Nav.Index()
        return

      'nav:main': ->
        rootView.showChildView 'header', new Nav.Main()
        return

    # All router must be initialized before backbone.history starts to work.

    new Router()

    # Start backbone history a main step to bookmarkable url's.

    Backbone.history.start
      pushState: true

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = new Application()

#-------------------------------------------------------------------------------
