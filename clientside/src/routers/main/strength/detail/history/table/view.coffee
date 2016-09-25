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
# Null View
#-------------------------------------------------------------------------------

class NullView extends Marionette.ItemView
  tagName: 'tr'
  template: nullTemplate

  #events:
  #  'click': ->
  #    @channel.request 'add'
  #    return

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

    models = options.sLogs.filter (model) ->
      dateA = moment(model.get('date')).startOf('day')
      dateB = moment(options.date).startOf('day')
      return dateA.isSame(dateB)

    super _.extend {}, options,
      collection: new Backbone.Collection models

    @mergeOptions options, [
      'channel'
      'date'
    ]

  childViewOptions: ->
    return {
      channel: @channel
    }

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------