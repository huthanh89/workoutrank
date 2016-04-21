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

  serializeData: ->
    return {
      status: @response.status
      title:  @response.statusText
      text:   @response.responseText
    }

  constructor: (options) ->
    super
    @mergeOptions options, 'response'

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------