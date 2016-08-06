#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
Marionette   = require 'marionette'
viewTemplate = require './view.jade'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'datepicker'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.ItemView

  template: viewTemplate

  ui:
    calendar: '#log-calendar-ui'

  constructor: ->
    super
    @rootChannel = Backbone.Radio.channel('root')

  onRender: ->

    dates = _.map @model.get('repData'), (data) -> moment(data.x).startOf('day').format()

    @ui.calendar.datepicker
      beforeShowDay: (date) ->
        index = _.indexOf dates, moment(date).startOf('day').format()
        return {
          enabled: if index isnt -1 then true else false
          classes: if index isnt -1 then 'log-calendar-td' else ''
          tooltip: ''
        }

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
