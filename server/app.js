//--------------------------------------------------------------
// Imports
//--------------------------------------------------------------

var express      = require('express');
var path         = require('path');
var favicon      = require('serve-favicon');
var logger       = require('morgan');
var mongoose     = require('mongoose');
var bodyParser   = require('body-parser');
var cookieParser = require('cookie-parser');
var session      = require('express-session');
var passport     = require('passport');

require('coffee-script/register');

//--------------------------------------------------------------
// Database and Models
//--------------------------------------------------------------

// Connect to Database.
mongoose.connect('mongodb://localhost:27017/local');

var db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error:'));
db.on('open', function callback () {
    console.log("MongoDb connection opened.");
});

//--------------------------------------------------------------
// // Create Schemas from models
//--------------------------------------------------------------

require('./models/user')(mongoose);
require('./models/exercise')(mongoose);
require('./models/strength')(mongoose);

//--------------------------------------------------------------
// Express
//--------------------------------------------------------------

var app = express();

//--------------------------------------------------------------
// Server for socket io
//--------------------------------------------------------------

var http   = require('http');
var server = http.createServer(app);

//--------------------------------------------------------------
// Application setup
//--------------------------------------------------------------

// view engine setup
// Set view's folder location and use jade as the engine
// starting from the root folder.
// /bin/www will look in this folder.

app.set('views', './static');
app.set('view engine', 'jade');

//--------------------------------------------------------------
// Application Level Middleware
//    It is important to note the the ordering of which
//    middleware is executed first before the other.
//--------------------------------------------------------------

app.use(logger('dev'));

// Handle cookie and session before defining routes.
// cookie parser should be used before the session.
// this order is required for the session to work.

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

// Able to read client's cookie.

app.use(cookieParser());

// Create cookie session.

app.use(session({
    secret: 'keyboard cat',
    resave: false,
    saveUninitialized: true,
    cookie: {}
}));
app.use(function(req, res, next) {
    next();
});

// Location of static files starting from the root or app.js.

app.use(express.static(path.join(__dirname, '../static')));
app.use('/strength', express.static(path.join(__dirname, '../static')));
app.use('/strength/:sid', express.static(path.join(__dirname, '../static')));

// Define all our routes.

var routes = require('./routes/index');

app.use('/', routes);

// catch 404 and forward to error handler

app.use(function(req, res, next) {
    var err = new Error('Not Found');
    err.status = 404;
    next(err);
});

//--------------------------------------------------------------
// Websocket Handler
//--------------------------------------------------------------

var port = 5000;


//var io = require('socket.io').listen(server);
//exports.io = io;

server.listen(port, function(){
    console.log('Express server listening on port %d in %s mode', port, app.get('env'));
});

//require('./socket');

//--------------------------------------------------------------
// Exports
//--------------------------------------------------------------

module.exports = app;

//--------------------------------------------------------------
