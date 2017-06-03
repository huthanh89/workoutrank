#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
Backbone     = require 'backbone'
Radio        = require 'backbone.radio'
Marionette   = require 'backbone.marionette'
Data         = require '../../data/module'
viewTemplate = require './view.pug'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'backbone.stickit'

#-------------------------------------------------------------------------------
# Channels
#-------------------------------------------------------------------------------

rootChannel = Radio.channel('root')

#-------------------------------------------------------------------------------
# Model
#-------------------------------------------------------------------------------

class Model extends Backbone.Model

  idAttribute: '_id'

  defaults:
    date:   moment()
    name:   ''
    muscle: []
    note:   ''
    body:   false

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.View

  template: viewTemplate

  ui:
    dialog: '#strength-modal-dialog'
    name:   '#strength-modal-name'
    muscle: '#strength-modal-muscle'
    body:   '#strength-modal-body'
    submit: '#strength-modal-submit'

  bindings:

    '#strength-modal-name': 'name'

    '#strength-modal-note': 'note'

    '#strength-modal-muscle':
      observe: 'muscle'
      onSet: (values) -> _.map values, (value) -> parseInt(value)

  events:

    'shown.bs.modal': ->
      @ui.body.prop 'checked', @model.get('body')
      return

    'click @ui.body': ->
      @model.set 'body', @ui.body.is(':checked')
      return

    'click #strength-modal-delete': (event) ->
      event.preventDefault()
      @model.destroy
        wait: true
        success: =>
          @redirect = true
          @ui.dialog.modal('hide')
          return
        error: (model, response) ->
          rootChannel.request 'message:error', response
          return

      return

    'submit': (event) ->
      event.preventDefault()

      @model.save {},
        success: =>
          @ui.dialog.modal('hide')
          return
        error: (model, response) ->
          rootChannel.request 'message:error', response
          return

      return

    'hidden.bs.modal': ->
      @ui.muscle.multiselect('destroy')
      Backbone.Radio.channel('root').request('strengths') if @redirect
      return

  constructor: (options) ->
    super
    @mergeOptions options, [
      'edit'
      'summary'
    ]
    @redirect = false

  onRender: ->
    @ui.muscle.multiselect
      maxHeight:     300
      dropRight:     true
      buttonWidth:  '100%'
      buttonClass:  'btn btn-default'
    .multiselect 'dataprovider', Data.Muscles

    @stickit()

    # Show this dialog

    @ui.dialog.modal()

    return

  onBeforeDestroy: ->
    $('.modal-backdrop').remove()
    $('body').removeClass 'modal-open'
    @unstickit()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Model = Model
module.exports.View  = View

#-------------------------------------------------------------------------------
