#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
nullTemplate = require './null.jade'
itemTemplate = require './item.jade'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Model
#-------------------------------------------------------------------------------

class Model extends Backbone.Model

  url: '/api/strength'

  idAttribute: '_id'

#-------------------------------------------------------------------------------
# Pageable Collection
#-------------------------------------------------------------------------------

class Collection extends Backbone.PageableCollection

  model: Model

  mode: 'client'

  constructor: (attributes, options) ->
    super
    @url = "/api/strength/#{options.id}/log"

  state:
    currentPage: 1
    pageSize:    10

  comparator: (item) -> return -item.get('date')

  parseRecords: (response) ->
    @date   = response.date
    @muscle = response.muscle
    @name   = response.name
    return response.log

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'multiselect'
require 'backbone.stickit'

#-------------------------------------------------------------------------------
# Null View
#-------------------------------------------------------------------------------

class NullView extends Marionette.ItemView
  tagName: 'tr'
  template: nullTemplate

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class ItemView extends Marionette.ItemView

  tagName: 'tr'

  template: itemTemplate


  bindings:

    '.strength-table-td-time':
      observe: 'date'
      onGet: (value) -> moment(value).format('h:mm A')

    '.strength-table-td-rep': 'rep'

    '.strength-table-td-weight': 'weight'

  events:
    'click .strength-table-td-remove': ->
      @model.destroy()
      return

  onRender: ->
    @stickit()
    return

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.CompositeView

  childViewContainer: 'tbody'

  childView: ItemView

  emptyView: NullView

  template: viewTemplate

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Model      = Model
module.exports.Collection = Collection
module.exports.View       = View

#-------------------------------------------------------------------------------
