#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Backbone   = require 'backbone'
Marionette = require 'marionette'
Account    = require './account/module'

#-------------------------------------------------------------------------------
# Router
#-------------------------------------------------------------------------------

class Router extends Marionette.AppRouter

  constructor: ->
    super
    @navChannel  = Backbone.Radio.channel('nav')
    @rootChannel = Backbone.Radio.channel('root')
    @rootView    = @rootChannel.request('rootview')

    # Replies for menu navigation.
    # Change the url path with @navigate('url path')
    # before being sent to route handler.
    # When changing url, set trigger true to trigger onRoute() call.

    @rootChannel.reply
      'account': =>
        @navigate('account')
        @account()
        return

  # Routes used for backbone urls.
  # Handle routes with APIs at the bottom.
  # Do not append "(/)" this will cause the view to load twice.
  # Appending "/" will suffice.

  routes:
    'account': 'account'

  # Api for Route handling.
  # Update Navbar and show view.

  account: ->
    @navChannel.request('nav:main')
    model = new Account.Model()
    model.fetch
      success: (model) =>
        @rootView.content.show new Account.View
          model: model
        return
      error: (model, response) =>
        @rootChannel.request 'message', 'danger', "Error: #{response.responseText}"
        return

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = Router

#-------------------------------------------------------------------------------
