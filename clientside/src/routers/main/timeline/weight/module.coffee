#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'backbone.stickit'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  bindings:

    '.timeline-weight-user': 'user'

    '.timeline-weight-date':
      observe: 'date'
      onGet: (value) -> moment(value).fromNow()

    '.timeline-weight-value': 'weight'

  constructor: ->
    super
    @userChannel = Backbone.Radio.channel('user').request('user')

  onRender: ->
    console.log @model.attributes

    @stickit @model
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.View = View

#-------------------------------------------------------------------------------
