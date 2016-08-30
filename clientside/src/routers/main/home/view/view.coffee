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

  bindings:
    '#home-exercise-count': 'sLogs'

    #'#home-schedule-count': 'schedules'
    #'#home-calendar-count': 'sLogs'
    #'#home-log-count':      'sConfs'

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

    'click #home-body': ->
      @rootChannel.request('body')
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

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')
    @user  = Backbone.Radio.channel('user').request 'user'

  onRender: ->

    gender = @user.get 'gender'

    @ui.bodyIcon.addClass(if gender then 'fa-male' else 'fa-female')

    @stickit()
    return


#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
