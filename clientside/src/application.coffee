
#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Backbone   = require 'backbone'
Marionette = require 'marionette'
NavView    = require './navbar/view'

router = require './routers/router'

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

    rootChannel.reply 'rootview': -> rootView

    # All router must be initialized before backbone.history starts to work.

    new router()

    # Start backbone history a main step to bookmarkable url's.

    Backbone.history.start
      pushState: true

    # Initialize the Root view and append the nav view to it.

    rootView.showChildView 'header', new NavView()

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = new Application()

#-------------------------------------------------------------------------------
