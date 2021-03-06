#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Marionette   = require 'backbone.marionette'
viewTemplate = require './view.pug'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'backbone.stickit'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.View
  template: viewTemplate

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------