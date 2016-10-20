#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

$            = require 'jquery'
moment       = require 'moment'
swal         = require 'sweetalert'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'backbone.stickit'
require 'touchspin'

#-------------------------------------------------------------------------------
# Given an array of models, return the latest date.
#-------------------------------------------------------------------------------

lastestWeight = (collection) ->
  model = _.maxBy collection.models, (model) -> model.get('date')
  return model.get('weight')

#-------------------------------------------------------------------------------
# Model
#-------------------------------------------------------------------------------

class Model extends Backbone.Model

  idAttribute: '_id'

  urlRoot: '/api/account'

  defaults:
    firstname: ''
    lastname:  ''
    email:     ''
    height:    0
    weight:    0
    birthday:  moment()

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  ui:
    height:   '#profile-height'
    weight:   '#profile-weight'
    gender:   '#profile-gender'
    submit:   '#profile-submit'
    birthday: '#profile-birthday'

  bindings:
    '#profile-firstname': 'firstname'
    '#profile-lastname':  'lastname'
    '#profile-email':     'email'
    '#profile-password':  'password'

    '#profile-height':
      observe: 'height'
      onSet: (value) -> parseInt(value)

    '#profile-weight':
      observe: 'weight'
      onSet: (value) -> parseInt(value)

  events:

    'click #profile-home': ->
      @rootChannel.request 'home'
      return

    'change #profile-gender': ->
      value = $('#profile-gender input:checked').val()
      @model.set('gender', parseInt(value, 10))
      return

    'click #profile-submit': (event) ->
      event.preventDefault()
      @rootChannel.request 'spin:page:loader', true

      @model.set 'birthday', @ui.birthday.data('DateTimePicker').date()

      @model.save null,
        success: (model) =>
          @rootChannel.request 'spin:page:loader', false
          swal('Success!', 'Profile Updated. Your ready to go off and use all our features. Click on the home button upper left.', 'success')
          return
        error: (model, response) =>
          @rootChannel.request 'message:error', response
          return

  constructor: (options) ->
    super
    @rootChannel = Backbone.Radio.channel('root')
    @mergeOptions options, [
      'wLogs'
      'isNew'
    ]

    if @wLogs.length > 0
      @model.set 'weight', lastestWeight(@wLogs)

  onRender: ->

    @ui.submit.hide() unless Backbone.Radio.channel('user').request 'isOwner'

    @ui.height.TouchSpin
      postfix:          'inches'
      buttondown_class: 'btn btn-info profile-weight-btn'
      buttonup_class:   'btn btn-info profile-weight-btn'
      min:              1
      max:              99999

    @ui.weight.TouchSpin
      postfix:          'pounds'
      buttondown_class: 'btn btn-info profile-weight-btn'
      buttonup_class:   'btn btn-info profile-weight-btn'
      min:              1
      max:              99999

    @stickit()
    return

  onShow: ->

    @ui.birthday.datetimepicker
      viewMode: 'years'
      format:   'YYYY-MM-DD'
      minDate:  moment().subtract(100, 'years')
      maxDate:  moment()
      widgetPositioning:
        vertical: 'top'
      ignoreReadonly: true

    @ui.birthday.data('DateTimePicker').date moment(@model.get('birthday'))

    gender = @model.get('gender')

    $("#profile-gender :radio[value=#{gender}]").prop 'checked', true

    # If is new, tell user to fill profile.

    if @isNew
      swal('Hi new user! Lets get started. ', 'Please fill out these info correctly and click update. We\'ll use it for later calculations.')

    return

  onBeforeDestroy: ->
    @ui.birthday.data('DateTimePicker').destroy()
    @ui.height.TouchSpin('destroy')
    @ui.weight.TouchSpin('destroy')
    @unstickit()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

exports.Model = Model
exports.View  = View

#-------------------------------------------------------------------------------
