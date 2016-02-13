#--------------------------------------------------------------------------------
# Imports
#--------------------------------------------------------------------------------

_            = require 'lodash'
$            = require 'jquery'
async        = require 'async'
Backbone     = require 'backbone'
Radio        = require 'backbone.radio'
Marionette   = require 'marionette'
ListView     = require './list/view'
viewTemplate = require './view.jade'

#--------------------------------------------------------------------------------
# Model
#--------------------------------------------------------------------------------

class Model extends Backbone.Model

#--------------------------------------------------------------------------------
# Pageable Collection
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

    @collection = new Collection()
    @collection.fetch()

    return

  onShow: ->
    @getRegion('listRegion').show new ListView
      collection: @collection
    return

#--------------------------------------------------------------------------------
# Exports
#--------------------------------------------------------------------------------

module.exports = View

#--------------------------------------------------------------------------------