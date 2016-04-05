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
# Plugins
#-------------------------------------------------------------------------------

require 'multiselect'
require 'backbone.stickit'

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

  state:
    currentPage: 1
    pageSize:    5

#-------------------------------------------------------------------------------
# Null View
#-------------------------------------------------------------------------------

class NullView extends Marionette.ItemView
  tagName: 'tr'
  template: nullTemplate

  events:
    'click': ->
      @channel.request 'add'
      return

  constructor: (options) ->
    super
    @mergeOptions options, 'channel'

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

    'click td:not(:first)': ->
      @rootChannel.request 'log:detail', @model.get('exercise')
      return

    'click .strength-table-td-remove': ->
      @model.urlRoot = '/api/slogs'
      @model.destroy
        wait: true
      return

  constructor: (options) ->
    super
    @rootChannel = Backbone.Radio.channel('root')

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

  constructor: (options) ->
    super
    @mergeOptions options, 'channel'

  childViewOptions: ->
    return {
      channel: @channel
    }

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Model      = Model
module.exports.Collection = Collection
module.exports.View       = View

#-------------------------------------------------------------------------------
