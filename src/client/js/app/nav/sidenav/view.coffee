#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

$            = require 'jquery'
Radio        = require 'backbone.radio'
Marionette   = require 'backbone.marionette'
viewTemplate = require './view.pug'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'mmenu'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.View

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

    'click #drawer-cardios': ->
      @channel.request 'cardios'
      @api.close()
      return

    'click #drawer-weight': ->
      @channel.request 'weights'
      @api.close()
      return

    'click #drawer-schedule': ->
      @channel.request 'schedule'
      @api.close()
      return

    'click #drawer-timeline': ->
      @channel.request 'timeline'
      @api.close()
      return

    'click #drawer-calendar': ->
      @channel.request 'calendar'
      @api.close()
      return

    'click #drawer-weights': ->
      @channel.request 'weights'
      @api.close()
      return

    'click #drawer-profile': ->
      @channel.request 'profile'
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

  constructor: (options) ->
    super(options)

    @channel = Radio.channel('root')

    @channel.reply

      'drawer:open': =>
        @api.open()
        return

      'drawer:close': =>
        @api.close()
        return

  onAttach: ->

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
            '<span>WorkoutRank</span>'
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