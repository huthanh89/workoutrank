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

    for user in response.users

      account =
        username:  user.username
        lastlogin: user.lastlogin
        provider:  user.provider

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

    '.admin-account-username':
      observe: 'username'
      onGet: (value) -> value or @model.get('provider')

    '.admin-account-sconfs':   'sConfs'
    '.admin-account-slogs':    'sLogs'
    '.admin-account-wlogs':    'wLogs'

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
exports.View       = View

#-------------------------------------------------------------------------------
