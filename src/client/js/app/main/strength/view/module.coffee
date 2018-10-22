#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

swal         = require 'sweetalert'
Radio        = require 'backbone.radio'
Marionette   = require 'backbone.marionette'
viewTemplate = require './view.pug'

#-------------------------------------------------------------------------------
# Channels
#-------------------------------------------------------------------------------

rootChannel = Radio.channel('root')
userChannel = Radio.channel('user')

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.View

  template: viewTemplate

  ui:
    bodyIcon: '#home-body-icon'
    admin:    '#home-admin-accounts-container'
    picture:  '#home-user-picture'

  bindings:
    '#home-sconf-count':    'sConfs'
    '#home-slog-count':     'sLogs'
    '#home-cconf-count':    'cConfs'
    '#home-clog-count':     'cLogs'
    '#home-wlog-count':     'wLogs'
    '#home-user-count':     'users'
    '#home-feedback-count': 'feedbacks'
    '#home-image-count':    'imageCount'
    '#home-schedule-count': 'scheduleCount'

  events:

    'click #home-help': ->
      swal
        title: 'Instructions'
        text:  'Start with adding some workouts in "Strength Training" and "Cardio Training"'
      return

    'click #home-user-picture': ->
      rootChannel.request('profile')
      return

    'click #home-strengths': ->
      rootChannel.request('strengths')
      return

    'click #home-cardios': ->
      rootChannel.request('cardios')
      return

    'click #home-logs': ->
      rootChannel.request('logs')
      return

    'click #home-calendar': ->
      rootChannel.request('calendar')
      return

    'click #home-schedule': ->
      rootChannel.request('schedule')
      return

    'click #home-weights': ->
      rootChannel.request('weights')
      return

    'click #home-timeline': ->
      rootChannel.request('timeline')
      return

    'click #home-logout': ->
      rootChannel.request('logout')
      return

    'click #home-profile': ->
      rootChannel.request('profile')
      return

    'click #home-account': ->
      rootChannel.request('account')
      return

    'click #home-admin-accounts': ->
      rootChannel.request('admin:accounts')
      return

    'click #home-admin-feedbacks': ->
      rootChannel.request('admin:feedbacks')
      return

  constructor: (options) ->
    super(options)
    @user = userChannel.request 'user'

  onRender: ->

    @ui.admin.removeClass 'hide' if @user.get('username') in ['tth', 'admin']

    gender = @user.get 'gender'

    @ui.bodyIcon.addClass(if gender then 'fa-male' else 'fa-female')

    @stickit()
    return

  onAttach: ->

    if @model.get('profilePic')
      @ui.picture[0].src = @model.get('profilePic').data

    # Scroll to top of page.
    
    window.scrollTo 0, 0

    return

  onBeforeDestroy: ->
    @unstickit()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
