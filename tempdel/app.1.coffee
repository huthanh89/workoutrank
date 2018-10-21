#--------------------------------------------------------------
# Imports
#--------------------------------------------------------------

path    = require 'path'
express = require 'express'

#--------------------------------------------------------------
# Create App and sub app.
#--------------------------------------------------------------

app  = express()

app.set("views", path.join(__dirname, "/dist"));

# Set view engine to be interpret as html.

app.set('view engine', 'html');

app.use('/', express.static(__dirname + '/dist'));
app.use('/home', express.static(__dirname + '/dist'));
app.use('/signup', express.static(__dirname + '/dist'));

app.get '/', (req, res) ->
  res.render('index')
  return

app.get '/home', (req, res) ->
  res.render('index')
  return

app.get '/signup', (req, res) ->
  res.render('index')
  return

#--------------------------------------------------------------
# Listen on port
#--------------------------------------------------------------

app.listen 5000, () => console.log('Math App listening on port 5000')

#--------------------------------------------------------------
# Exports
#--------------------------------------------------------------

module.exports = app

#--------------------------------------------------------------
