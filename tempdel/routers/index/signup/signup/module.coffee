#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
Backbone     = require 'backbone'
Radio        = require 'backbone.radio'
Marionette   = require 'backbone.marionette'
viewTemplate = require './view.pug'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'backbone.stickit'
require 'bootstrap.datetimepicker'

#-------------------------------------------------------------------------------
# Channels
#-------------------------------------------------------------------------------

rootChannel = Radio.channel('root')

#-------------------------------------------------------------------------------
# Model
#-------------------------------------------------------------------------------

class Model extends Backbone.Model

  url: 'api/signup'

  defaults:
    email:     ''
    username:  ''
    password:  ''
    captcha:   ''

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.View

  template: viewTemplate

  ui:
    form:     '#signup-form'
    gender:   '#signup-gender'
    spinner:  '#signup-spinner'

  bindings:
    '#signup-email':    'email'
    '#signup-username': 'username'
    '#signup-password': 'password'

  events:
    'click @ui.signup': ->
      rootChannel.request('index')
      return

    'submit': (event) ->
      event.preventDefault()
      rootChannel.request 'spin:page:loader', true

      captcha = _.find(@ui.form.serializeArray(), name: 'g-recaptcha-response')?.value
      @model.set 'captcha', captcha

      window.grecaptcha.reset()

      @model.save {},
        success: ->
          rootChannel.request 'spin:page:loader', false
          rootChannel.request('profile', true)
          return
        error: (model, response) ->
          rootChannel.request 'message:error', response
          return

      return

    'click #signup-login': ->
      rootChannel.request('login')
      return

  constructor: (options) ->
    super(options)
    @mergeOptions options, [
      'channel'
    ]

  onRender: ->
    @stickit()
    return

  onAttach: ->
    @timer = setTimeout =>
      @ui.spinner.addClass 'hide'
      window.grecaptcha.render 'signup-recaptcha',
        'sitekey' : '6LeGeBwTAAAAAFYqtUAHlRQxSOrNqYeugtn7Z527',
        'theme' : 'light'
      return
    , 3000

    return

  onBeforeDestroy: ->
    clearTimeout(@timer)
    @unstickit()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Model = Model
module.exports.View  = View

#-------------------------------------------------------------------------------
