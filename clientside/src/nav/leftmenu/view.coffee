#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_            = require 'lodash'
$            = require 'jquery'
Backbone     = require 'backbone'
Radio        = require 'backbone.radio'
Marionette   = require 'marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'mmenu'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  className: 'mm-light'
  tagName:   'nav'

  ui:
    menu: '.drawer-menu'

  events:
    'click #drawer-home': ->
      @channel.request 'home'
      return

    'click #drawer-journals': ->
      @channel.request 'strengths'
      return

    'click #drawer-graphs': ->
      @channel.request 'logs'
      return

  constructor: ->
    super

    @channel = Radio.channel('root')

    @channel.reply

      'drawer:open': =>
        @api.open()
        return

      'drawer:close': =>
        @api.close()
        return

  onShow: ->

    menu = $(@el)

    menu.mmenu()

    ###
    menu.mmenu

      extensions: [
        'multiline'
        'border-none'
      ]
      slidingSubmenus: false
      navbars: [{
        position: 'top'
        title:    'My photos'
      }]

###

    @api = menu.mmenu().data( "mmenu" )

    @openMenu()

    return

  openMenu: ->
    @api.open()
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------