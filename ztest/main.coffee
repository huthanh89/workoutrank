#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

_       = require 'lodash'
express = require 'express'
http    = require 'http'
debug   = require 'debug'

StatsD       = require 'node-statsd'
responseTime = require 'response-time'
finalhandler = require 'finalhandler'

#-------------------------------------------------------------------------------
# Port Number
#-------------------------------------------------------------------------------

port = 80

#-------------------------------------------------------------------------------
# Create App
#-------------------------------------------------------------------------------

app = express()

stats = new StatsD()

#-------------------------------------------------------------------------------
# Create server and listener
#-------------------------------------------------------------------------------

server = http.createServer app

server.listen port, ->
  console.log 'my app listening on port 80'
  return

server.on 'error', ->
  console.log 'ERRROORR', arguments
  return

server.on 'listening', ->
  addr = server.address()
  bind = if typeof addr == 'string' then 'pipe ' + addr else 'port ' + addr.port
  debug 'Listening on ' + bind
  return

#-------------------------------------------------------------------------------
# Middlewares - application level
#-------------------------------------------------------------------------------

stats.socket.on 'error', (error) ->
  console.error error.stack
  return


app.use responseTime((req, res, time) ->
  console.log req.method, req.url, res.statusCode, '-', _.round(time, 3)
)

#-------------------------------------------------------------------------------
# Middlewares - router level
#-------------------------------------------------------------------------------

app.get '/', (req, res) ->
  res.send 'Hello Worldfdd!'
  return

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = app

#-------------------------------------------------------------------------------
