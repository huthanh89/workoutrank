
#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

GA           = require './ga'
Toastr       = require 'toastr'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
Nav          = require './nav/module'
Message      = require './message/module'
IndexRouter  = require './routers/index/router'
MainRouter   = require './routers/main/router'
UserRouter   = require './routers/user/router'

#-------------------------------------------------------------------------------
# User
#-------------------------------------------------------------------------------

class User extends Backbone.Model

  url: '/api/user'

  defaults:
    firstname: ''
    lastname:  ''
    email:     ''

#-------------------------------------------------------------------------------
# RootView
#-------------------------------------------------------------------------------

class RootView extends Marionette.LayoutView
  el: 'body'
  regions:
    header:  '#header'
    message: '#message-container'
    content: '#content'
    index:   '#index'
    drawer:  '#drawer'

#-------------------------------------------------------------------------------
# Create Application.
#-------------------------------------------------------------------------------

class Application extends Marionette.Application

  onStart: ->

    # Start Google analytics

    googleAnalytics = new GA()

    # Fetch user record.

    user = new User()

    # Start channels.

    rootView = new RootView()

    # user: get user related info
    # root: call methods at the root level(including page navigations)
    # nav:  used to show which kind of navbar on top

    userChannel = Backbone.Radio.channel('user')
    rootChannel = Backbone.Radio.channel('root')
    navChannel  = Backbone.Radio.channel('nav')

    userChannel.reply
      'user': -> user

    rootChannel.reply

      'rootview': -> rootView

      'message': (panelType, panelText) ->

        rootView.showChildView 'message', new Message.Info
          panelType: panelType
          panelText: panelText
        return

      'message:error': (response) ->

        Toastr.options =
          closeButton:       true
          debug:             false
          newestOnTop:       false
          progressBar:       true
          positionClass:    'toast-top-full-width'
          preventDuplicates: false
          onclick:           null
          showDuration:     '300'
          hideDuration:     '1000'
          timeOut:          '5000'
          extendedTimeOut:  '1000'
          showEasing:       'swing'
          hideEasing:       'linear'
          showMethod:       'fadeIn'
          hideMethod:       'fadeOut'

        Toastr.error(response.responseText, "Error: #{response.status}")

        ###
        rootView.showChildView 'message', new Message.Error
          response: response
###
        return

    navChannel.reply

      'nav:index': ->

        rootView.showChildView 'header', new Nav.Index()

        rootView.showChildView 'drawer', new Nav.Drawer()

        return

      'nav:main': ->
        user.fetch
          success: (model) ->

            rootView.showChildView 'header', new Nav.Main
              model: user

            rootView.showChildView 'drawer', new Nav.Drawer()

            return
          error: (model, response) ->
            rootChannel.request 'message', 'danger', "Error: #{response.responseText}"
            return
        return

    # All router must be initialized before backbone.history starts to work.

    new IndexRouter
      mode:          'auto'
      trailingSlash: 'ignore'

    new MainRouter
      mode:          'auto'
      trailingSlash: 'ignore'

    new UserRouter
      mode:          'auto'
      trailingSlash: 'ignore'

    # Event is triggered the user navigate through out a page.

    Backbone.history.on 'route', (router, route, params) ->

      # Send route url to google analytics.

      googleAnalytics.send(route)

      return

    # Start backbone history a main step to bookmarkable url's.

    Backbone.history.start
      pushState:  true
      hashChange: false

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = new Application()

#-------------------------------------------------------------------------------
