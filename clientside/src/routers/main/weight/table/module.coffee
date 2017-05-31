#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'backbone.marionette'
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

  url: '/api/wlogs'

  idAttribute: '_id'

#-------------------------------------------------------------------------------
# Pageable Collection
#-------------------------------------------------------------------------------

class Collection extends Backbone.Collection

  comparator: (model) -> -moment(model.get('date')).utc()

  model: Model

#-------------------------------------------------------------------------------
# Null View
#-------------------------------------------------------------------------------

class NullView extends Marionette.View
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

class ItemView extends Marionette.View

  tagName: 'tr'

  template: itemTemplate

  ui:
    change:  '.strength-table-td-change'
    percent: '.strength-table-td-percent'

  bindings:

    '.strength-table-td-time':
      observe: 'date'
      onGet: (value) -> moment(value).format('h:mm A')

    '.strength-table-td-weight': 'weight'

    '.strength-table-td-change':
      observe: 'change'
      updateMethod: 'html'
      onGet: (value) ->
        if value > 0
          return "<span style='color:red;'>+#{value}</span>"
        else if value < 0
          return "<span style='color:green;'>#{value}</span>"
        else
          return "<span style='color:green;'>+#{value}</span>"

    '.strength-table-td-percent':
      observe:      'percent'
      updateMethod: 'html'
      onGet: (value) ->
        if value > 0
          return "<span style='color:red;'>(+#{value}%)</span>"
        else if value < 0
          return "<span style='color:green;'>(#{value}%)</span>"
        else
          return "<span style='color:green;'>(+#{value}%)</span>"

    '.strength-table-td-growth':
      observe:      'change'
      updateMethod: 'html'
      onGet: (value) ->

        span = "<span>#{value}</span>"

        if value < 0
          return "<i class='fa fa-fw fa-lg fa-long-arrow-down' style='color:#3b9f38'></i>"
        else if value > 0
          return "<i class='fa fa-fw fa-lg fa-long-arrow-up' style='color:rgba(232, 33, 30, 0.84);'></i>"
        else
          return "<i class='fa fa-fw fa-lg fa-minus' style='color:#3b9f38'></i>"

  events:
    'click .strength-table-td-remove': ->
      @model.urlRoot = '/api/wlogs'
      @model.destroy
        wait: true
      return

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')

  onRender: ->
    @stickit()
    return

  onBeforeDestroy: ->
    @unstickit()
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
