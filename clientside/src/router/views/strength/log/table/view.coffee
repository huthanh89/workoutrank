#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
Backbone     = require 'backbone'
Marionette   = require 'marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  bindings:
    '#strength-log-table-name':   'name'
    '#strength-log-table-max':    'max'
    '#strength-log-table-min':    'min'
    '#strength-log-table-avg':    'avg'
    '#strength-log-table-target': 'exercise'
    '#strength-log-table-date':   'date'

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')

  render: ->
    console.log 'rendersss'
    #@stickit()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
