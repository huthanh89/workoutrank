
#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

GA           = require './ga'
GCT          = require './gct'
Toastr       = require 'toastr'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
Nav          = require './nav/module'
ErrorView    = require './error/view'
FooterView   = require './footer/view'
Loader       = require './loader/module'
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
    height:    0
    gender:    0
    auth:      1

#-------------------------------------------------------------------------------
# RootView
#-------------------------------------------------------------------------------

class RootView extends Marionette.LayoutView
  el: 'body'
  regions:
    header:  '#header'
    loader:  '#loader'
    content: '#content'
    index:   '#index'
    footer:  '#footer'
    drawer:  '#drawer'

#-------------------------------------------------------------------------------
# Create Application.
#-------------------------------------------------------------------------------

class Application extends Marionette.Application

  # Send route url to google analytics.
  # Send conversion data for specific routes.

  trackAnalytics: (route) ->
    @googleAnalytics.send(route)
    if route is 'signup'
      @googleTrackingConversion.send()
    return

  onStart: ->

    # Start Google analytics

    @googleAnalytics = new GA()

    # Start Google adword conversion tracker.

    @googleTrackingConversion = new GCT()

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
      user: -> user

      auth: -> user.get('auth')

      isOwner: -> parseInt(user.get('auth'), 10) is 1

    rootChannel.reply

      # Workaround for the refresh and navigate which will called twice.
      # Trigger set to false so method will not get called twice.

      navigate: (route, options) =>
        Backbone.history.navigate route, trigger:false
        @trackAnalytics route
        return

      'rootview': -> rootView

      'message:error': (response) ->

        rootChannel.request 'spin:page:loader', false

        if response.status is 401
          rootView.showChildView 'content', new ErrorView()

        else

          Toastr.options =
            closeButton:       true
            debug:             false
            newestOnTop:       false
            progressBar:       true
            positionClass:    'toast-top-full-width'
            preventDuplicates: false
            onclick:           null
            showDuration:     '10000'
            hideDuration:     '10000'
            timeOut:          '10000'
            extendedTimeOut:  '10000'
            showEasing:       'swing'
            hideEasing:       'linear'
            showMethod:       'fadeIn'
            hideMethod:       'fadeOut'

          Toastr.error(response.responseText, "Error: #{response.status} #{response.statusText}")

      'spin:page:loader': (enable) ->
        if enable
          rootView.showChildView 'loader', new Loader.View()
        else
          rootView.getRegion('loader').empty()
        return

    navChannel.reply

      'nav:index': ->
        rootChannel.request 'drawer:close'
        rootView.showChildView 'header', new Nav.Index()
        rootView.showChildView 'drawer', new Nav.Drawer()
        return

      'nav:main': ->

        rootChannel.request 'drawer:close'
        rootView.getRegion('index').empty()

        user.fetch
          success: (model) ->
            rootView.showChildView 'header', new Nav.Main
              model: user
            rootView.showChildView 'drawer', new Nav.Drawer()
            return
          error: (model, response) ->
            rootChannel.request 'message:error', response
            return
        return

    rootView.footer.show new FooterView()

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

    # Called when url is changed during navigation.

    Backbone.history.on 'route', (router, route) =>
      @trackAnalytics route
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
