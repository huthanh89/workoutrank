#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Backbone     = require 'backbone'
Marionette   = require 'backbone.marionette'
Login        = require './login/module'
viewTemplate = require './view.pug'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.View

  template: viewTemplate

  regions:
    login: '#login-view'

  constructor: (options) ->
    super(options)
    @channel = Backbone.Radio.channel('channel')

  onAttach: ->
    @showChildView 'login', new Login.View
      model:   new Login.Model()
      channel: @channel
    return

  onDestroy: ->
    @channel.reset()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
