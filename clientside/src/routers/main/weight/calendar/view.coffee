#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

moment       = require 'moment'
Marionette   = require 'backbone.marionette'
viewTemplate = require './view.pug'

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

require 'datepicker'

#-------------------------------------------------------------------------------
# View
#-------------------------------------------------------------------------------

class View extends Marionette.View

  template: viewTemplate

  ui:
    calendar: '#weight-calendar-ui'

  onRender: ->
    dates = _.map @collection.models, (model) ->
      return moment(model.get('date')).startOf('day').format()

    @ui.calendar.datepicker
      beforeShowDay: (date) ->
        index = _.indexOf dates, moment(date).startOf('day').format()
        return {
          enabled: if index isnt -1 then true else false
          classes: if index isnt -1 then 'weight-calendar-td' else ''
          tooltip: ''
        }

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = View

#-------------------------------------------------------------------------------
