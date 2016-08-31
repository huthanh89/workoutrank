#-------------------------------------------------------------------------------
# Google Conversion Tracking (Adwords)
#
#   Send report to google Adwords.
#-------------------------------------------------------------------------------

class GoogleConversionTracker

  send: ->

    console.log 'sending'

    window.google_trackConversion
      google_conversion_id:        958303564
      google_conversion_language: 'en'
      google_conversion_format:   '3'
      google_conversion_color:    'ffffff'
      google_conversion_label:    'cC-oCMqy72kQzJr6yAM'
      google_remarketing_only:     false

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = GoogleConversionTracker

#-------------------------------------------------------------------------------
