#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Backbone     = require 'backbone'
Marionette   = require 'marionette'
Signup       = require './signup/module'
Login        = require './login/module'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  ui:
    spinner: '#index-spinner-view'

  regions:
    signup: '#index-signup-view'
    login:  '#index-login-view'

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')
    @channel = Backbone.Radio.channel('channel')

  onShow: ->

    @showChildView 'signup', new Signup.View
      model:   new Signup.Model()
      channel: @channel

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
