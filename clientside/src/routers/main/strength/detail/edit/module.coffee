#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
Data         = require '../../data/module'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'backbone.stickit'

#-------------------------------------------------------------------------------
# Model
#-------------------------------------------------------------------------------

class Model extends Backbone.Model

  idAttribute: '_id'

  defaults:
    date:   moment()
    name:   ''
    muscle: 0
    note:   ''
    body:   false

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.LayoutView

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
      onSet: (value) -> parseInt(value)

  events:

    'shown.bs.modal': ->
      @ui.name.focus()
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
      return

    'submit': (event) ->
      event.preventDefault()

      @model.save {},
        success: =>
          @ui.dialog.modal('hide')
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
    @rootChannel = Backbone.Radio.channel('root')
    @redirect    = false

  onRender: ->
    @ui.muscle.multiselect
      maxHeight:     330
      buttonWidth:  '100%'
      buttonClass:  'btn btn-default'
    .multiselect 'dataprovider', Data.Muscles
    .multiselect('select', @model.get('muscle'))

    @stickit()

    # Show this dialog

    @ui.dialog.modal()

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports.Model = Model
module.exports.View  = View

#-------------------------------------------------------------------------------
