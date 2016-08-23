#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

$            = require 'jquery'
swal         = require 'sweetalert'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
Summary      = require './summary/module'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'backbone.stickit'
require 'touchspin'

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
    weight:    null

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

  template: viewTemplate

  regions:
    summary: '#account-summary'

  ui:
    weight: '#account-weight'
    gender: '#account-gender'

  bindings:
    '#account-firstname': 'firstname'
    '#account-lastname':  'lastname'
    '#account-email':     'email'
    '#account-password':  'password'

    '#account-weight':
      observe: 'weight'
      onSet: (value) -> parseInt(value)

  events:

    'click #account-home': ->
      @rootChannel.request 'home'
      return

    'change #account-gender': ->
      value = $('#account-gender input:checked').val()
      @model.set('gender', parseInt(value, 10))
      return

    'submit': (event) ->
      event.preventDefault()
      @rootChannel.request 'spin:page:loader', true
      @model.save null,
        success: (model) =>
          @rootChannel.request 'spin:page:loader', false
          swal('Success', 'Profile Updated!', 'success')
          return
        error: (model, response) =>
          @rootChannel.request 'message:error', response
          return

  constructor: (options) ->
    super
    @rootChannel = Backbone.Radio.channel('root')

  onRender: ->

    @ui.weight.TouchSpin
      postfix:          'pounds'
      buttondown_class: 'btn btn-default'
      buttonup_class:   'btn btn-default'
      min:              1
      max:              99999

    @stickit()
    return

  onShow: ->
    @showChildView 'summary', new Summary.View
      model: @model

    gender = @model.get('gender')
    $("#account-gender :radio[value=#{gender}]").prop 'checked', true

    return

  onBeforeDestroy: ->
    @ui.weight.TouchSpin('destroy')
    @unstickit()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

exports.Model = Model
exports.View  = View

#-------------------------------------------------------------------------------
