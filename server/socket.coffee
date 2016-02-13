#--------------------------------------------------------------
# Import
#--------------------------------------------------------------

io = require('./app').io

#--------------------------------------------------------------
# Handlers
#--------------------------------------------------------------

io.on 'connection', (socket) ->
  console.log 'New Client connected2 -------------->'
  Twitter = require 'twitter'
  inspect = require('eyespect').inspector()

  client = new Twitter
    consumer_key:        'FdE3OIEzPttU9Dw3Jf8xpAqPW'
    consumer_secret:     'ucZGlEOaDF8K7MIrYwz04biOD5JThbWk3kVvwFixCndKA2Upgo'
    access_token_key:    '2378524963-kn57V0iYZNwYnWjxvHussYMDC5ynbDdDq45VFwX'
    access_token_secret: 'y6ZnDJSc7HSpUVMQZsmg13RPp9Fzkt5gwlCQippl86VhA'

  client.stream 'statuses/filter', {
      track: 'heroes of the storm'
    }, (stream) ->

      stream.on 'data', (tweet) ->
        socket.emit 'tweets', tweet
        return

      stream.on 'error', (error) ->
        socket.emit 'tweetError', error.source
        return

  return

#--------------------------------------------------------------