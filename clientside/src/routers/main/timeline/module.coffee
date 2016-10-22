#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

$            = require 'jquery'
_            = require 'lodash'
moment       = require 'moment'
swal         = require 'sweetalert'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
Strength     = require './strength/module'
Weight       = require './weight/module'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'waypoint'
require 'infinite'

#-------------------------------------------------------------------------------
# SLogs Collection
#-------------------------------------------------------------------------------

class SLogCollection extends Backbone.Collection
  url: 'api/slogs'

#-------------------------------------------------------------------------------
# Helping functions
#-------------------------------------------------------------------------------

getChange = (value, prev, index) ->

  growth  = 'same'
  change  = 0
  percent = 0

  if index > 0
    growth  = 'up'   if value > prev
    growth  = 'down' if value < prev
    change  = _.round value - prev , 2
    percent = _.round (value / prev) * 100 - 100, 2

  return {
    growth:  growth
    change:  change
    percent: percent
  }

#-------------------------------------------------------------------------------
# Parse sLogs
#-------------------------------------------------------------------------------

parseSLogs = (sLogs, sConfs) ->

  result = []

  #meanRep    = _.meanBy sLogs, (model) -> model.get('rep')
  #meanWeight = _.meanBy sLogs, (model) -> model.get('weight')

  repPrev    = 0
  weightPrev = 0

  for model, index in sLogs

    sConf = sConfs.get(model.get('exercise'))

    if sConf

      repReduce    = getChange model.get('rep'), repPrev, index
      repPrev      = model.get('rep')
      weightReduce = getChange model.get('weight'), weightPrev, index
      weightPrev   = model.get('weight')

      result.push _.extend {}, model.attributes,
        type: 'strength'
        name: sConf.get('name')
        repGrowth:     repReduce.growth
        repChange:     repReduce.change
        repPercent:    repReduce.percent
        weightGrowth:  weightReduce.growth
        weightChange:  weightReduce.change
        weightPercent: weightReduce.percent

  return result

#-------------------------------------------------------------------------------
# Parse wLogs
#-------------------------------------------------------------------------------

parseWLogs = (wLogs) ->

  result = []

  mean = _.meanBy wLogs, (model) -> model.get('weight')
  prev = 0

  for model, index in wLogs

    weight = model.get('weight')

    avg = 'same'
    avg = 'up'   if weight > mean
    avg = 'down' if weight < mean

    reduce = getChange(weight, prev, index)

    prev = model.get('weight')

    result.push _.extend {}, model.attributes,
      type:   'weight'
      avg:     avg
      growth:  reduce.growth
      change:  reduce.change
      percent: reduce.percent

  return result

#-------------------------------------------------------------------------------
# Collection
#-------------------------------------------------------------------------------

class Collection extends Backbone.Collection

  comparator: (model) -> -moment(model.get('date')).utc()

  parse: (response, options) ->

    sConfs = options.sConfs
    sLogs  = options.sLogs.models
    wLogs  = options.wLogs.models
    result = []

    # Parse for sLog data.

    result.push parseSLogs sLogs, sConfs

    # Parse for wLog data.

    result.push parseWLogs wLogs

    return _.flatten result

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class ListView extends Marionette.CollectionView

  serializeData: -> {}

  getChildView: (model) ->
    return if model.get('type') is 'strength' then Strength.View else Weight.View

  collectionEvents:
    update: ->
      @point()
      return

  # Client side lazy rendering of our whole collection.
  # Break models into chunks. Display 5 chunks at a time per load.

  constructor: (options) ->

    models  = options.collection.models
    @chunks = _.chunk models, 5
    @index  = 1

    super _.extend {}, options,
      collection: new Collection @chunks[0]
    @rootChannel = Backbone.Radio.channel('root')

  onShow: ->
    @point()
    return

  point: ->

    container = $('#timeline-view')

    container.append '<a class="infinite-more-link href="//asfdasfd"></a>'

    infinite = new Waypoint.Infinite
      element: container[0]
      more: '.infinite-more-link'

      onBeforePageLoad: =>
        models = @chunks[@index]
        if models
          @collection.add models
          @index++
        return

#-------------------------------------------------------------------------------
# Composite View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView
  template: viewTemplate

  ui:
    list: '#timeline-view'

  regions:
    list: '#timeline-view'

  events:
    'click #timeline-home':  ->
      @rootChannel.request 'home'
      return

    'click #timeline-help': ->
      swal
        title: 'Instructions'
        text:  'The timeline shows recorded logs. Try adding some entries in your journal first, then come back here to see them automatically posted.'
      return

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')

  onShow: ->
    @showChildView 'list', new ListView
      collection: @collection
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.SLogCollection = SLogCollection
module.exports.Collection     = Collection
module.exports.View           = View

#-------------------------------------------------------------------------------
