#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

$            = require 'jquery'
moment       = require 'moment'
swal         = require 'sweetalert'
Backbone     = require 'backbone'
Radio        = require 'backbone.radio'
Marionette   = require 'backbone.marionette'
viewTemplate = require './view.pug'

#-------------------------------------------------------------------------------
# Channels
#-------------------------------------------------------------------------------

rootChannel = Radio.channel('root')
userChannel = Radio.channel('user')

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
# View
#-------------------------------------------------------------------------------

class View extends Marionette.View

  template: viewTemplate

  ui:
    height:   '#profile-height'
    weight:   '#profile-weight'
    gender:   '#profile-gender'
    submit:   '#profile-submit'
    birthday: '#profile-birthday'
    picture:  '#profile-picture'
    upload:   '#profile-upload'

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

    'click #profile-picture-delete': ->
      @ui.picture.attr 'src', './images/profile-icon.png'
      @model.resetImage()
      return

    'change #profile-upload': (object) ->

      preview = @ui.picture[0]
      file    = $(object.target)[0].files[0]
      reader  = new FileReader()

      # Upload image to preview.

      reader.addEventListener 'load', =>
        preview.src = reader.result

        @model.set file
        @model.set
          data: reader.result

        return
      , false

      # Get the image source.

      if file
        reader.readAsDataURL file

      return

    'click #profile-home': ->
      rootChannel.request 'home'
      return

    'click #profile-help': ->
      swal
        title: 'Instructions'
        text:  'It is important you fill out your profile accurately. The information here will help us in your workout calculations.'
      return

    'change #profile-gender': ->
      value = $('#profile-gender input:checked').val()
      @model.set('gender', parseInt(value, 10))
      return

    'click #profile-submit': (event) ->
      event.preventDefault()
      rootChannel.request 'spin:page:loader', true

      @model.set 'birthday', @ui.birthday.data('DateTimePicker').date()

      @model.save null,
        success: ->
          rootChannel.request 'spin:page:loader', false

          swal
            title: 'Success!'
            text:  'Profile Updated. Your ready to go off and use all our features.',
            type:  'success'
          , ->
            rootChannel.request 'home'
            return

          return
        error: (model, response) ->
          rootChannel.request 'message:error', response
          return

  constructor: (options) ->
    super(options)
    @mergeOptions options, [
      'wLogs'
      'isNew'
    ]

    if @wLogs.length > 0
      @model.set 'weight', lastestWeight(@wLogs)

  onRender: ->

    @ui.submit.hide() unless userChannel.request 'isOwner'

    @ui.height.TouchSpin
      buttondown_class: 'btn btn-secondary profile-weight-btn'
      buttonup_class:   'btn btn-secondary profile-weight-btn'
      min:              1
      max:              99999

    @ui.weight.TouchSpin
      buttondown_class: 'btn btn-secondary profile-weight-btn'
      buttonup_class:   'btn btn-secondary profile-weight-btn'
      min:              1
      max:              99999

    @stickit()
    return

  onAttach: ->

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


    if @model.get('data')
      @ui.picture[0].src = @model.get 'data'

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

export default View

#-------------------------------------------------------------------------------
