#--------------------------------------------------------------------------------
# Imports
#--------------------------------------------------------------------------------

_            = require 'lodash'
$            = require 'jquery'
async        = require 'async'
Backbone     = require 'backbone'
Radio        = require 'backbone.radio'
Marionette   = require 'marionette'
FeedView     = require './feed/view'
viewTemplate = require './view.jade'

#--------------------------------------------------------------------------------
# Model
#--------------------------------------------------------------------------------

class Model extends Backbone.Model

#--------------------------------------------------------------------------------
# Collection
#--------------------------------------------------------------------------------

class Collection extends Backbone.Collection
  url: 'api/movies'
  model: Model

#--------------------------------------------------------------------------------
# View
#--------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  regions:
    listRegion: '#movies-list-region'

  initialize: ->
    console.log 'init detail'
    return

  onShow: ->

    @getRegion('listRegion').show new FeedView
      collection: new Collection()
    return

#--------------------------------------------------------------------------------
# Exports
#--------------------------------------------------------------------------------

module.exports = View

#--------------------------------------------------------------------------------