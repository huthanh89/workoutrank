#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Backbone     = require 'backbone'
Marionette   = require 'marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'backbone.stickit'
require 'backbone.validation'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:
    form:    '#index-signup-form'
    submit:  '#index-signup-submit'
    spinner: '#signup-spinner'

  events:

    'click @ui.login': ->
      @rootChannel.request('login')
      return

      return

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
