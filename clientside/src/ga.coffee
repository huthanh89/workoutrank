#-------------------------------------------------------------------------------
# Google Analytics
#
#   Send report to google analytics.
#-------------------------------------------------------------------------------

class GoogleAnalytic

  send: (route) ->

    # Set username and id.

    _gaq = _gaq or []
    _gaq.push [
      '_setAccount'
      'UA-74126093-1'
    ]

    # Get javascript.

    do ->
      ga = document.createElement('script')
      ga.type = 'text/javascript'
      ga.async = true
      ga.src = (
        if 'https:' == document.location.protocol
        then 'https://ssl'
        else 'http://www'
      ) + '.google-analytics.com/ga.js'
      s = document.getElementsByTagName('script')[0]
      s.parentNode.insertBefore ga, s

    # Call the track page view function and append route.
#    _gaq.push(['_trackPageview', "/#{route}"])

    ga('set', 'page', "/#{route}")

    # Send page view to google analytics.

    ga('send', 'pageview', "/#{route}")

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = GoogleAnalytic

#-------------------------------------------------------------------------------
