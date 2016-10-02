#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

async      = require 'async'
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

    @rootChannel.reply
      'admin:accounts': =>
        @rootChannel.request 'navigate', 'admin/accounts'
        @accounts()
        return

  routes:
    'admin/accounts': 'accounts'

  accounts: ->

    @navChannel.request('nav:main')

    collection = new Account.Collection()
    collection.fetch
      success: (collection) =>
        @rootView.content.show new Account.View
          collection: collection
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
