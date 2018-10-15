//--------------------------------------------------------------
// Coffeescript plugin to read .coffee files.
//--------------------------------------------------------------
var MongoStore, adminApp, app, async, auth, bodyParser, compression, config, cookieParser, db, express, favicon, html, http, i, len, logger, moment, mongoose, passport, path, ref, routers, server, session, url;

require('coffee-script/register');

//--------------------------------------------------------------
// Register all models to mongoose object.
//--------------------------------------------------------------
require('./models/facebook');

require('./models/feedback');

require('./models/google');

require('./models/schedule');

require('./models/strength');

require('./models/slog');

require('./models/cardio');

require('./models/clog');

require('./models/token');

require('./models/twitter');

require('./models/user');

require('./models/wlog');

require('./models/image');

//--------------------------------------------------------------
// Imports
//--------------------------------------------------------------
async = require('async');

moment = require('moment');

express = require('express');

path = require('path');

favicon = require('serve-favicon');

logger = require('morgan');

mongoose = require('mongoose');

bodyParser = require('body-parser');

cookieParser = require('cookie-parser');

session = require('express-session');

http = require('http');

compression = require('compression');

MongoStore = require('connect-mongo')(session);

passport = require('passport');

auth = require('./auth');

config = require('./config');

routers = require('./routers/module');

html = require('html');

//--------------------------------------------------------------
// Database Connection
//--------------------------------------------------------------

// Handle deprecated "mpromise" library warning.
mongoose.Promise = global.Promise;

// Connect to Database.

//mongoose.connect config.databaseUrl, config.databaseOptions
mongoose.connect(config.databaseUrl);

db = mongoose.connection;

db.on('error', console.error.bind(console, 'MongoDB Connection Error:'));

db.on('open', function() {
  console.log('MongoDb connection opened.');
});

//--------------------------------------------------------------
// Configure and initialize passport.
//--------------------------------------------------------------
passport.serializeUser(auth.serializeUser);

passport.deserializeUser(auth.deserializeUser);

passport.use(auth.localStrategy);

passport.use(auth.facebookStrategy);

passport.use(auth.twitterStrategy);

passport.use(auth.googleStrategy);

//--------------------------------------------------------------
// Create App and sub app.
//--------------------------------------------------------------
app = express();

adminApp = require('./admin/app');

//--------------------------------------------------------------
// Create server using app.
//--------------------------------------------------------------
server = http.createServer(app);

//--------------------------------------------------------------
// Configure view engine to render EJS templates.

//   Set view's folder location and use jade as the engine
//   starting from the root folder.
//   /bin/www will look in this folder.
//--------------------------------------------------------------

// Tell express to look for views in the following directory.
console.log('>>>>>', path.join(__dirname, "../../dist"));

app.set("views", path.join(__dirname, "../../dist"));

app.set('view engine', 'jade');

ref = ['', '/cardio', '/cardio/:cid', '/strength', '/strength/:sid', '/log', '/log/:lid', '/admin'];
for (i = 0, len = ref.length; i < len; i++) {
  url = ref[i];
  app.use(url, function(req, res, next) {
    console.log(path.join(__dirname, '../../dist'));
    res.setHeader('Expires', new Date(Date.now() + 2592000000).toUTCString());
    next();
  }, express.static(path.join(__dirname, '../../dist'), {
    maxAge: 86400000
  }));
}

// By the time the user gets here, there is no more route handlers.
// Return a NOT FOUND 404 error and render the error page.
app.get('*', function(req, res) {
  console.log('-------------- 4 0 4 ----------');
  // res.status 404
  res.render('404.jade');
});

// If an error occurred in the app, catch it in the middleware.
// catch 404 and forward to error handler
//  res.end()
app.use(function(err, req, res) {
  //console.log 'ERROR', err
  console.trace();
  res.render('error', {
    error: err
  });
});

//--------------------------------------------------------------
// Listen on port
//--------------------------------------------------------------
server.listen(config.port, function() {
  console.log('Express server listening on port %d in %s mode', config.port, app.get('env'));
});

//--------------------------------------------------------------
// Exports
//--------------------------------------------------------------
module.exports = app;

//--------------------------------------------------------------
