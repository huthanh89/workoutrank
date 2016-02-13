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

    '.twitter-profile':
      observe: 'profile_image_url_https'
      updateMethod: 'html'
      onGet: ->
        url = @model.get('profile_image_url_https')
        return '<img src=' + url + '></img>'

    '#date':
      observe: 'created_at'
      onGet: (date)->
        return moment(date).format('MMMM Do YYYY, h:mm:ss a')

    '#username':
      observe: 'screen_name'

    '#comment':
      observe: 'text'

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