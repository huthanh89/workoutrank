//--------------------------------------------------------------
// Imports
//--------------------------------------------------------------

var express      = require('express');
var path         = require('path');
var favicon      = require('serve-favicon');
var logger       = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser   = require('body-parser');
var mongoose     = require('mongoose');
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

var http = require('http');
var server = http.createServer(app);

//--------------------------------------------------------------
// view engine setup
//--------------------------------------------------------------

// Set view's folder location and use jade as the engine
// starting from the root folder.
// /bin/www will look in this folder.
//app.set('views', './views');
app.set('views', './static');
app.set('view engine', 'jade');

//--------------------------------------------------------------
// Middleware
//--------------------------------------------------------------

app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());

// Location of static files starting from the root or app.js.

console.log(path.join(__dirname, '/../static'));
console.log(path.join(__dirname, '../static'));
console.log(path.join(__dirname, 'static'));

app.use(express.static(path.join(__dirname, '../static')));

app.use('/strength', express.static(path.join(__dirname, '../static')));
app.use('/strength/:sid', express.static(path.join(__dirname, '../static')));

app.use(session({
    secret: 'keyboard cat',
    resave: false,
    saveUninitialized: true,
    cookie: { secure: true }
}));

//--------------------------------------------------------------
// Passport Middleware
//--------------------------------------------------------------


//--------------------------------------------------------------
// Application Middleware
//--------------------------------------------------------------

var routes = require('./routes/index');

app.use('/', routes);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
    var err = new Error('Not Found');
    err.status = 404;
    next(err);
});

//--------------------------------------------------------------
// Error Handlers
//--------------------------------------------------------------

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
    app.use(function(err, req, res, next) {
        res.status(err.status || 500);
        res.render('error', {
            message: err.message,
            error: err
        });
    });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.render('error', {
        message: err.message,
        error: {}
    });
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
