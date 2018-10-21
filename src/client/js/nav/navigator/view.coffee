#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

$            = require 'jquery'
Radio        = require 'backbone.radio'
Marionette   = require 'backbone.marionette'
viewTemplate = require './view.pug'

#-------------------------------------------------------------------------------
# Channels
#-------------------------------------------------------------------------------

rootChannel = Radio.channel('root')

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.View

  template: viewTemplate

  ui:
    container: '#navigator-bottom-container'

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

  constructor: (options) ->
    super(options)

    @route = ''

    rootChannel.reply
      'clear:navigation': (route) =>
        if @route isnt route
          $(@el).find('li').removeClass 'active'
        return

  # Workaround to hide bottom navigator when mobile keybaord is up.
  # The navigator is too obtrusive, so we want to hide them.

  onAttach: ->
    $('body').delegate 'input', 'focusin', (element) =>
      if element.target.type in ['number', 'text']
        @ui.container.addClass 'hidden'
      return

    $('body').delegate 'input', 'focusout', =>
      @ui.container.removeClass 'hidden'
      return

    $('body').delegate 'textarea', 'focusin', =>
      @ui.container.addClass 'hidden'
      return

    $('body').delegate 'textarea', 'focusout', =>
      @ui.container.removeClass 'hidden'
      return
    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------