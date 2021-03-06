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
# Collection
#-------------------------------------------------------------------------------

class Collection extends Backbone.Collection

  comparator: (model) -> -moment(model.get('date')).utc()

#-------------------------------------------------------------------------------
# Null View
#-------------------------------------------------------------------------------

class NullView extends Marionette.View
  tagName: 'div'
  template: nullTemplate

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class ItemView extends Marionette.View

  tagName: 'tr'

  template: itemTemplate

  bindings:

    '.strength-table-td-time':
      observe: 'date'
      onGet: (value) -> moment(value).format('h:mm A')

    '.strength-table-td-rep': 'rep'

    '.strength-table-td-rep-change':
      observe: 'changeRep'
      updateMethod: 'html'
      onGet: (value) ->
        if value > 0
          return "<span style='color:green;'>+#{value}</span>"
        else if value < 0
          return "<span style='color:red;'>#{value}</span>"
        else
          return "<span style='color:green;'>+#{value}</span>"

    '.strength-table-td-rep-percent':
      observe:      'percentRep'
      updateMethod: 'html'
      onGet: (value) ->
        if value > 0
          return "<span style='color:green;'>(+#{value}%)</span>"
        else if value < 0
          return "<span style='color:red;'>(#{value}%)</span>"
        else
          return "<span style='color:green;'>(+#{value}%)</span>"

    '.strength-table-td-rep-growth':
      observe:      'changeRep'
      updateMethod: 'html'
      onGet: (value) ->

        span = "<span>#{value}</span>"

        if value < 0
          return "<i class='fas fa-fw fa-lg fa-arrow-down' style='color:red'></i>"
        else if value > 0
          return "<i class='fas fa-fw fa-lg fa-arrow-up' style='color:green;'></i>"
        else
          return "<i class='fa fa-fw fa-lg fa-minus' style='color:green;'></i>"

    '.strength-table-td-weight': 'weight'

    '.strength-table-td-weight-change':
      observe: 'changeWeight'
      updateMethod: 'html'
      onGet: (value) ->
        if value > 0
          return "<span style='color:green;'>+#{value}</span>"
        else if value < 0
          return "<span style='color:red;'>#{value}</span>"
        else
          return "<span style='color:green;'>+#{value}</span>"

    '.strength-table-td-weight-percent':
      observe:      'percentWeight'
      updateMethod: 'html'
      onGet: (value) ->
        if value > 0
          return "<span style='color:green;'>(+#{value}%)</span>"
        else if value < 0
          return "<span style='color:red;'>(#{value}%)</span>"
        else
          return "<span style='color:green;'>(+#{value}%)</span>"

    '.strength-table-td-weight-growth':
      observe:      'changeWeight'
      updateMethod: 'html'
      onGet: (value) ->

        span = "<span>#{value}</span>"

        if value < 0
          return "<i class='fas fa-fw fa-lg fa-arrow-down' style='color:red'></i>"
        else if value > 0
          return "<i class='fas fa-fw fa-lg fa-arrow-up' style='color:green;'></i>"
        else
          return "<i class='fa fa-fw fa-lg fa-minus' style='color:green;'></i>"

  events:
    'click .strength-table-td-remove': ->
      @model.urlRoot = '/api/slogs'
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

    clean = options.sLogs.clone()

    models = options.sLogs.filter (model, index) ->
      dateA  = moment(model.get('date')).startOf('day')
      dateB  = moment(options.date).startOf('day')
      result = dateA.isSame(dateB)

      if result and (index > 0)
        prev    =  clean.at(index - 1).get('rep')
        current = model.get('rep')
        model.set 'changeRep',  _.round current - prev , 2
        model.set 'percentRep', _.round (current / prev) * 100 - 100 , 2

        prev    =  clean.at(index - 1).get('weight')
        current = model.get('weight')
        model.set 'changeWeight',  _.round current - prev , 2
        model.set 'percentWeight', _.round (current / prev) * 100 - 100 , 2
      else
        model.set 'changeRep',     0
        model.set 'percentRep',    0
        model.set 'changeWeight',  0
        model.set 'percentWeight', 0

      return result

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
