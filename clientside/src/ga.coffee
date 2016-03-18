#-------------------------------------------------------------------------------
# Google Analytics
#
#   Send report to google analytics.
#-------------------------------------------------------------------------------

class GoogleAnalytic

  send: (route) ->

    # Google analytics

    _gaq = _gaq or []
    _gaq.push [
      '_setAccount'
      'UA-74126093-1'
    ]
    _gaq.push [ '_trackPageview' ]

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
    _gaq.push(['_trackPageview', "/#{route}"])
    ga('send', 'pageview')

    return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = GoogleAnalytic

#-------------------------------------------------------------------------------
