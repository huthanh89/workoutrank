#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

async      = require 'async'
Radio      = require 'backbone.radio'
Marionette = require 'backbone.marionette'
AppRouter  = require 'marionette.approuter'
Account    = require './account/module'
Feedback   = require './feedback/module'

#-------------------------------------------------------------------------------
# Channels
#-------------------------------------------------------------------------------

navChannel  = Radio.channel('nav')
rootChannel = Radio.channel('root')

#-------------------------------------------------------------------------------
# Router
#-------------------------------------------------------------------------------

class Router extends AppRouter.default

  constructor: (options) ->
    super(options)

    @rootView = rootChannel.request('rootview')

    rootChannel.reply
      'admin:accounts': =>
        rootChannel.request 'navigate', 'admin/accounts'
        @accounts()
        return

      'admin:feedbacks': =>
        rootChannel.request 'navigate', 'admin/feedbacks'
        @feedbacks()
        return

  routes:
    'admin/accounts':  'accounts'
    'admin/feedbacks': 'feedbacks'

  accounts: ->

    navChannel.request('nav:main')

    collection = new Account.Collection()
    collection.fetch
      success: (collection) =>
        @rootView.showChildView 'content', new Account.View
          collection: collection
        return
      error: (model, response) ->
        rootChannel.request 'message', 'danger', "Error: #{response.responseText}"
        return
    return

  feedbacks: ->

    navChannel.request('nav:main')

    collection = new Feedback.Collection()
    collection.fetch
      success: (collection) =>
        @rootView.showChildView 'content', new Feedback.View
          collection: collection
        return
      error: (model, response) ->
        rootChannel.request 'message', 'danger', "Error: #{response.responseText}"
        return
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = Router

#-------------------------------------------------------------------------------
