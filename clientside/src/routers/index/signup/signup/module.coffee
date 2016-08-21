#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'backbone.stickit'
require 'bootstrap.datetimepicker'

#-------------------------------------------------------------------------------
# Model
#-------------------------------------------------------------------------------

class Model extends Backbone.Model

  url: 'api/signup'

  defaults:
    email:     ''
    username:  ''
    password:  ''
    birthday:  new Date()
    captcha:   ''

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:
    form:     '#signup-form'
    birthday: '#signup-birthday'
    gender:   '#signup-gender'
    spinner:  '#signup-spinner'

  bindings:
    '#signup-email':    'email'
    '#signup-username': 'username'
    '#signup-password': 'password'

  events:
    'click @ui.signup': ->
      @rootChannel.request('index')
      return

    'submit': (event) ->
      event.preventDefault()
      @rootChannel.request 'spin:page:loader', true
      @model.set 'birthday', @ui.birthday.data('DateTimePicker').date()

      captcha = _.find(@ui.form.serializeArray(), name: 'g-recaptcha-response')?.value
      @model.set 'captcha', captcha

      @model.save {},
        success: (model) =>
          @rootChannel.request 'spin:page:loader', false
          @rootChannel.request('home')
          return
        error: (model, response) =>
          window.grecaptcha.reset()
          @rootChannel.request 'message:error', response
          return

      return

    'click #signup-login': ->
      @rootChannel.request('login')
      return

  constructor: (options) ->
    super
    @rootChannel = Backbone.Radio.channel('root')
    @mergeOptions options, 'channel'

  onRender: ->
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

    @timer = setTimeout =>
      @ui.spinner.addClass 'hide'
      window.grecaptcha.render 'signup-recaptcha',
        'sitekey' : '6LeGeBwTAAAAAFYqtUAHlRQxSOrNqYeugtn7Z527',
        'theme' : 'light'
      return
    , 3000

    return

  onBeforeDestroy: ->
    @ui.birthday.data('DateTimePicker').destroy()
    clearTimeout(@timer)
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Model = Model
module.exports.View  = View

#-------------------------------------------------------------------------------