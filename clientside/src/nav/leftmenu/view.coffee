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
      @api.close()
      return

    'click #drawer-journals': ->
      @channel.request 'strengths'
      @api.close()
      return

    'click #drawer-schedule': ->
      @channel.request 'schedule'
      @api.close()
      return

    'click #drawer-calendar': ->
      @channel.request 'calendar'
      @api.close()
      return

    'click #drawer-graphs': ->
      @channel.request 'logs'
      @api.close()
      return

    'click #drawer-account': ->
      @channel.request 'account'
      @api.close()
      return

    'click #drawer-logout': ->
      @channel.request 'logout'
      @api.close()
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

    menu.mmenu
      extensions: [
        'border-full'
        'pagedim-black'
        'pageshadow'
        #'theme-dark'
      ]

      offCanvas:
        zposition: 'front'

      navbars: [
        {
          position: 'bottom'
          content: [
            '<a class=\'fa fa-envelope\'></a>'
            '<a class=\'fa fa-twitter\'></a>'
            '<a class=\'fa fa-facebook\'></a>'
          ]
        }
      ]
    ,
      offCanvas:
        pageSelector: '#drawer'

    @api = menu.mmenu().data( "mmenu" )

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------