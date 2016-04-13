#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

Backbone     = require 'backbone'
Marionette   = require 'marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'backbone.stickit'
require 'backbone.validation'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:
    form:    '#signup-form'
    login:   '#index-tab-login'
    submit:  '#index-signup-submit'
    spinner: '#signup-spinner'

  bindings:
    '#index-signup-firstname': 'firstname'
    '#index-signup-lastname':  'lastname'
    '#index-signup-email':     'email'
    '#index-signup-password':  'password'

  events:

    'click @ui.login': ->
      @rootChannel.request('login')
      return

    submit: (event) ->
      event.preventDefault()

      captcha = _.find(@ui.form.serializeArray(), name: 'g-recaptcha-response')?.value

      @model.set 'captcha', captcha

      @model.save {},
        success: =>
          @rootChannel.request('home')
          return
        error: (model, response) =>
          console.log 'response', response, response.responseText

          @rootChannel.request 'message', 'danger', "Error: #{response.responseText}"
          return

      return

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')

  # Bind validation to view and model.

  initialize: ->
    Backbone.Validation.bind(@, @model)
    @model.validate()
    return

  onRender: ->
    @stickit()
    return

  onShow: ->
    setTimeout =>
      @ui.spinner.hide()
      window.grecaptcha.render 'signup-recaptcha',
        'sitekey' : '6LeGeBwTAAAAAFYqtUAHlRQxSOrNqYeugtn7Z527',
        'theme' : 'light'
      return
    , 3000
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
