#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Backbone     = require 'backbone'
Marionette   = require 'marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Model
#-------------------------------------------------------------------------------

class Model extends Backbone.Model
  defaults:
    name: ''

#-------------------------------------------------------------------------------
# Collection
#-------------------------------------------------------------------------------

class Collection extends Backbone.Collection
  url:  'api/profile'
  model: Model

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:
    reps:      '#reps'
    touchspin: '#touchspin'

  events:
    'click #stat-home': ->
      @rootChannel.request 'home'
      return

  constructor: (options) ->
    super
    @rootChannel = Backbone.Radio.channel('root')

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

exports.Model      = Model
exports.Collection = Collection
exports.View       = View

#-------------------------------------------------------------------------------
