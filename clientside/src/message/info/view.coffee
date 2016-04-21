#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

$            = require 'jquery'
_            = require 'lodash'
Backbone     = require 'backbone'
Radio        = require 'backbone.radio'
Marionette   = require 'marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'backbone.stickit'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:
    message: '#message'
    text:    '#message-type'

  constructor: (options) ->
    super
    @mergeOptions options, [
      'panelType'
      'panelText'
    ]

  onShow: ->
    @ui.message.addClass "alert-#{@panelType}"
    @ui.text.html "#{@panelText}"
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------