
#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Backbone   = require 'backbone'
Marionette = require 'marionette'
Nav        = require './nav/module'
Router     = require './router/router'


trackPage = ()->
  console.log 'tracking page'
  return

#-------------------------------------------------------------------------------
# RootView
#-------------------------------------------------------------------------------

class RootView extends Marionette.LayoutView
  el: 'body'
  regions:
    header:  '.header'
    content: '.content'

#-------------------------------------------------------------------------------
# Create Application.
#-------------------------------------------------------------------------------

class Application extends Marionette.Application

  navigate: ->
    console.log 'navigate'
    return

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


    Backbone.history.on 'route', (router, route, params) ->

      # Google analytics

      _gaq = _gaq or []
      _gaq.push [
        '_setAccount'
        'UA-74126093-1'
      ]
      _gaq.push [ '_trackPageview' ]

      do ->
        ga = document.createElement('script')
        ga.type = 'text/javascript'
        ga.async = true
        ga.src = (
          if 'https:' == document.location.protocol
          then 'https://ssl'
          else 'http://www'
        ) + '.google-analytics.com/ga.js'
        s = document.getElementsByTagName('script')[0]
        s.parentNode.insertBefore ga, s
      _gaq.push(['_trackPageview', "/#{route}"])
      ga('send', 'pageview')

      return

    # Start backbone history a main step to bookmarkable url's.

    Backbone.history.start
      pushState: true

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = new Application()

#-------------------------------------------------------------------------------
