#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
Backbone     = require 'backbone'
Radio        = require 'backbone.radio'
Marionette   = require 'backbone.marionette'
itemTemplate = require './item.jade'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'backbone.stickit'
require 'touchspin'

#-------------------------------------------------------------------------------
# Channels
#-------------------------------------------------------------------------------

rootChannel = Radio.channel('root')

#-------------------------------------------------------------------------------
# Collection
#-------------------------------------------------------------------------------

class Collection extends Backbone.Collection

  url: '/admin/api/feedbacks'

  comparator: (item) -> -moment(item.get('lastlogin')).utc()

#-------------------------------------------------------------------------------
# ItemView
#-------------------------------------------------------------------------------

class ItemView extends Marionette.View

  tagName: 'tr'

  template: itemTemplate

  bindings:
    '.admin-feedback-date':
      observe: 'date'
      onGet: (value) -> moment(value).format('MM/DD hh:mma')
    '.admin-feedback-title': 'title'
    '.admin-feedback-text':  'text'

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
  childView:          ItemView
  template:           viewTemplate

  events:
    'click #admin-home': ->
      rootChannel.request 'home'
      return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

exports.Collection = Collection
exports.View       = View

#-------------------------------------------------------------------------------
