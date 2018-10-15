#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Backbone     = require 'backbone'
Marionette   = require 'backbone.marionette'
Signup       = require './signup/module'
viewTemplate = require './view.pug'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.View

  template: viewTemplate

  ui:
    spinner: '#spinner-view'

  regions:
    signup: '#signup-view'
    login:  '#login-view'

  constructor: ->
    super
    @channel = Backbone.Radio.channel('channel')

  onAttach: ->
    @showChildView 'signup', new Signup.View
      model:   new Signup.Model()
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
