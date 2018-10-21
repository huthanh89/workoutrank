
#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Radio        = require 'backbone.radio'
Toastr       = require 'toastr'
Marionette   = require 'backbone.marionette'
Nav          = require './nav/module'
LoaderView   = require './loader/view'
FooterView   = require './footer/view'
viewTemplate = require './view.pug'

#-------------------------------------------------------------------------------
# Channels
#-------------------------------------------------------------------------------

navChannel  = Radio.channel('nav')
rootChannel = Radio.channel('root')
userChannel = Radio.channel('user')

#-------------------------------------------------------------------------------
# RootView
#-------------------------------------------------------------------------------

class View extends Marionette.View

  template: viewTemplate

  regions:
    header:    '#header'
    loader:    '#loader'
    content:   '#content'
    index:     '#index'
    footer:    '#footer'
    navigator: '#navigator'
    drawer:    '#drawer'

  constructor: (options) ->

    super(options);

    user = options.user

    userChannel.reply

      user:    -> user

      auth:    -> user.get('auth')

      isOwner: -> parseInt(user.get('auth'), 10) is 1

      logout:  -> user.clear().set user.defaults

    rootChannel.reply

      'rootview': => @

      'message:error': (response) ->

        rootChannel.request 'spin:page:loader', false

        #if response.status is 401
        #  @showChildView 'content', new ErrorView()
        #else

        Toastr.options =
          closeButton:       true
          debug:             false
          newestOnTop:       false
          progressBar:       true
          preventDuplicates: false
          onclick:           null
          showDuration:     '5000'
          hideDuration:     '5000'
          timeOut:          '5000'
          extendedTimeOut:  '5000'
          showEasing:       'swing'
          hideEasing:       'linear'
          showMethod:       'fadeIn'
          hideMethod:       'fadeOut'
          positionClass:    'toast-top-center'

        Toastr.error(response.responseText, "Error: #{response.status} #{response.statusText}")

      'spin:page:loader': (enable) =>
        if enable
          @showChildView 'loader', new LoaderView()
        else
          @getRegion('loader').empty()
        return

    navChannel.reply

      'nav:index': =>
        rootChannel.request 'drawer:close'
        @showChildView 'header', new Nav.Index()
        @showChildView 'drawer', new Nav.Drawer()
        return

      'nav:basic': =>
        rootChannel.request 'drawer:close'
        @showChildView 'header', new Nav.Basic()
        @showChildView 'drawer', new Nav.Drawer()
        return

      'nav:main': =>

        rootChannel.request 'drawer:close'
        @getRegion('index').empty()

        user.fetch
          success: =>
            @showChildView 'header', new Nav.Main
              model: user
            @showChildView 'drawer', new Nav.Drawer()
            return
          error: (model, response) ->
            rootChannel.request 'message:error', response
            return
        return

  onRender: ->
    @showChildView 'navigator', new Nav.Navigator()
    @showChildView 'footer',    new FooterView()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
