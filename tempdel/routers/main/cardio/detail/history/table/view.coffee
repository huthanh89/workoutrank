#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'backbone.marionette'
nullTemplate = require './null.pug'
itemTemplate = require './item.pug'
viewTemplate = require './view.pug'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'multiselect'
require 'backbone.stickit'

#-------------------------------------------------------------------------------
# Model
#-------------------------------------------------------------------------------

class Model extends Backbone.Model

  urlRoot: '/api/cLogs'
  idAttribute: '_id'

#-------------------------------------------------------------------------------
# Collection
#-------------------------------------------------------------------------------

class Collection extends Backbone.Collection

  model: Model

  comparator: (model) -> -moment(model.get('created')).utc()

#-------------------------------------------------------------------------------
# Null View
#-------------------------------------------------------------------------------

class NullView extends Marionette.View
  tagName: 'tr'
  template: nullTemplate

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class ItemView extends Marionette.View

  tagName: 'tr'

  template: itemTemplate

  bindings:

    '.cardio-table-td-time':
      observe: 'date'
      onGet: (value) -> moment(value).format('h:mm A')

    '.cardio-table-td-rep': 'duration'

    '.cardio-table-td-rep-change':
      observe: 'changeDuration'
      updateMethod: 'html'
      onGet: (value) ->
        if value > 0
          return "<span style='color:green;'>+#{value}</span>"
        else if value < 0
          return "<span style='color:red;'>#{value}</span>"
        else
          return "<span style='color:green;'>+#{value}</span>"

    '.cardio-table-td-rep-percent':
      observe:      'percentDuration'
      updateMethod: 'html'
      onGet: (value) ->
        if value > 0
          return "<span style='color:green;'>(+#{value}%)</span>"
        else if value < 0
          return "<span style='color:red;'>(#{value}%)</span>"
        else
          return "<span style='color:green;'>(+#{value}%)</span>"

    '.cardio-table-td-rep-growth':
      observe:      'changeDuration'
      updateMethod: 'html'
      onGet: (value) ->

        span = "<span>#{value}</span>"

        if value < 0
          return "<i class='fa fa-fw fa-lg fa-long-arrow-down' style='color:red'></i>"
        else if value > 0
          return "<i class='fa fa-fw fa-lg fa-long-arrow-up' style='color:green;'></i>"

    '.cardio-table-td-intensity':
      observe: 'intensity'
      onGet: (value) -> value or '---'

    '.cardio-table-td-speed':
      observe: 'speed'
      onGet: (value) -> value or '---'

  events:
    'click .cardio-table-td-remove': ->
      @model.destroy
        wait: true
      return

  onRender: ->
    @stickit()
    return

  onBeforeDestroy: ->
    @unstickit()
    return

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.CollectionView

  childViewContainer: 'tbody'

  childView: ItemView

  emptyView: NullView

  template: viewTemplate

  constructor: (options) ->

    clean = options.cLogs.clone()

    sLogs = options.cLogs.filter (model, index) ->
      dateA  = moment(model.get('date')).startOf('day')
      dateB  = moment(options.date).startOf('day')
      result = dateA.isSame(dateB)

      if result and (index > 0)
        prev     = clean.at(index - 1).get('duration')
        current  = model.get('duration')
        duration = current - prev

        model.set 'changeDuration',  _.round duration , 2

        percent = (current / prev) * 100 - 100
        model.set 'percentDuration', _.round percent , 2

      else
        model.set 'changeDuration',  0
        model.set 'percentDuration', 0

      return result

    models = []

    for sLog in sLogs
      models.push new Model sLog.attributes

    super _.extend {}, options,
      collection: new Collection models

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
