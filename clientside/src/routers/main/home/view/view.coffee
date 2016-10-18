#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Backbone     = require 'backbone'
Marionette   = require 'marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:
    bodyIcon: '#home-body-icon'
    admin:    '#home-admin-accounts-container'

  bindings:
    '#home-sconf-count': 'sConfs'
    '#home-slog-count':  'sLogs'
    '#home-wlog-count':  'wLogs'
    '#home-user-count':  'users'

  events:

    'click #home-strengths': ->
      @rootChannel.request('strengths')
      return

    'click #home-logs': ->
      @rootChannel.request('logs')
      return

    'click #home-calendar': ->
      @rootChannel.request('calendar')
      return

    'click #home-schedule': ->
      @rootChannel.request('schedule')
      return

    'click #home-weights': ->
      @rootChannel.request('weights')
      return

    'click #home-timeline': ->
      @rootChannel.request('timeline')
      return

    'click #home-logout': ->
      @rootChannel.request('logout')
      return

    'click #home-profile': ->
      @rootChannel.request('profile')
      return

    'click #home-account': ->
      @rootChannel.request('account')
      return

    'click #home-admin-accounts': ->
      @rootChannel.request('admin:accounts')
      return

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')
    @user  = Backbone.Radio.channel('user').request 'user'

  onRender: ->

    @ui.admin.removeClass 'hide' if @user.get('username') in ['tth', 'admin']

    gender = @user.get 'gender'

    @ui.bodyIcon.addClass(if gender then 'fa-male' else 'fa-female')

    @stickit()
    return

  onBeforeDestroy: ->
    @unstickit()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
