#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

$            = require 'jquery'
Radio        = require 'backbone.radio'
Marionette   = require 'backbone.marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Channels
#-------------------------------------------------------------------------------

rootChannel = Radio.channel('root')

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.View

  template: viewTemplate

  events:
    'click li': (element) ->
      @select element.target
      return

    'click i': (element) ->
      @select  $(element.target).parent()[0]
      return

  select: (element) ->

    return unless element.tagName is 'LI'

    $(@el).find('li').removeClass 'active'
    selector = $(element)
    selector.addClass 'active'

    @route = selector.data('route')

    rootChannel.request selector.data('route')
    return

  constructor: ->
    super

    @route = ''

    rootChannel.reply
      'clear:navigation': (route) =>
        if @route isnt route
          $(@el).find('li').removeClass 'active'
        return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------