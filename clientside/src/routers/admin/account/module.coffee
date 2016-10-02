#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
itemTemplate = require './item.jade'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'backbone.stickit'
require 'touchspin'

#-------------------------------------------------------------------------------
# Model
#-------------------------------------------------------------------------------

class Model extends Backbone.Model

  idAttribute: '_id'

  urlRoot: 'admin/api/accounts'

  defaults:
    firstname: ''
    lastname:  ''
    email:     ''

#-------------------------------------------------------------------------------
# Collection
#-------------------------------------------------------------------------------

class Collection extends Backbone.Collection
  url: '/admin/api/accounts'

#-------------------------------------------------------------------------------
# ItemView
#-------------------------------------------------------------------------------

class ItemView extends Marionette.ItemView

  tagName: 'tr'

  template: itemTemplate

  ui:
    index: '.admin-account-index'

  bindings:

    '.admin-account-username': 'username'

    '.admin-account-lastlogin':
      observe: 'lastlogin'
      onGet: (value) -> moment(value).format('MM/DD - hh:mm a')

  onRender: ->
    @ui.index.html @_index + 1
    @stickit()
    return

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------


class View extends Marionette.CompositeView

  childViewContainer: 'tbody'
  childView:          ItemView
  template:           viewTemplate

  regions:
    summary: '#admin-summary'

  events:
    'click #admin-home': ->
      @rootChannel.request 'home'
      return

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

exports.Collection = Collection
exports.Model      = Model
exports.View       = View

#-------------------------------------------------------------------------------
