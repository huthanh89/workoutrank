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
# Collection
#-------------------------------------------------------------------------------

class Collection extends Backbone.Collection

  url: '/admin/api/accounts'

  comparator: (item) -> -moment(item.get('lastlogin')).utc()

  parse: (response) ->

    result = []

    for user, index in response.users
      account =
        username:  user.username
        lastlogin: user.lastlogin
        provider:  user.provider
        firstname: user.firstname
        lastname:  user.lastname

      sLogs = _.filter response.sLogs, (log) -> log.user is user._id
      account.sLogs = sLogs.length

      sConfs = _.filter response.sConfs, (log) -> log.user is user._id
      account.sConfs = sConfs.length

      wLogs = _.filter response.wLogs, (log) -> log.user is user._id
      account.wLogs = wLogs.length

      result.push account

    return result

#-------------------------------------------------------------------------------
# ItemView
#-------------------------------------------------------------------------------

class ItemView extends Marionette.ItemView

  tagName: 'tr'

  template: itemTemplate

  ui:
    index: '.admin-account-index'

  bindings:

    '.admin-account-index':     'index'
    '.admin-account-username':  'username'
    '.admin-account-provider':  'provider'
    '.admin-account-firstname': 'firstname'
    '.admin-account-lastname':  'lastname'
    '.admin-account-sconfs':    'sConfs'
    '.admin-account-slogs':     'sLogs'
    '.admin-account-wlogs':     'wLogs'

    '.admin-account-lastlogin':
      observe: 'lastlogin'
      onGet: (value) -> moment(value).format('MM/DD - hh:mm a')

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
      @rootChannel.request 'home'
      return

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')

    length = @collection.length

    @collection.each (model, index) ->
      model.set 'index', length - index
      return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

exports.Collection = Collection
exports.View       = View

#-------------------------------------------------------------------------------
