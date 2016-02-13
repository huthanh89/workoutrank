#--------------------------------------------------------------------------------
# Imports
#--------------------------------------------------------------------------------

_           = require 'lodash'
Marionette  = require 'marionette'
Application = require 'src/application'

#--------------------------------------------------------------------------------
# View
#--------------------------------------------------------------------------------

class View extends Marionette.ItemView
  template: _.template 'turn up'
  initialize: ->
    console.log 'init2'
    return

#--------------------------------------------------------------------------------
# Exports
#--------------------------------------------------------------------------------

module.exports = View

#--------------------------------------------------------------------------------
