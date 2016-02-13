#--------------------------------------------------------------------------------
# Imports
#--------------------------------------------------------------------------------

_            = require 'lodash'
$            = require 'jquery'
moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
viewTemplate = require './view.jade'

require 'stickit'

#--------------------------------------------------------------------------------
# Item View
#--------------------------------------------------------------------------------

class View extends Marionette.ItemView
  template: viewTemplate

  bindings:

    '#date':
      observe: 'date'
      onGet: (date)->
        return moment(date).format('MMMM Do YYYY, h:mm:ss a')

    '#username':
      observe: 'username'

    '#comment':
      observe: 'comment'

  initialize:(model, options) ->
    return

  onRender: ->
    @stickit @model
    return

#--------------------------------------------------------------------------------
# Exports
#--------------------------------------------------------------------------------

module.exports = View

#--------------------------------------------------------------------------------