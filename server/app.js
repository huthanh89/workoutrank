var MongoStore, adminApp, app, async, auth, bodyParser, compression, cookieParser, db, express, favicon, http, logger, moment, mongoose, passport, path, port, routers, server, session, staticFiles;

require('coffee-script/register');

require('./models/facebook');

require('./models/feedback');

require('./models/google');

require('./models/schedule');

require('./models/slog');

require('./models/strength');

require('./models/token');

require('./models/twitter');

require('./models/user');

require('./models/wlog');

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

mongoose.connect('mongodb://localhost:27017/local');

db = mongoose.connection;

db.on('error', console.error.bind(console, 'connection error:'));

db.on('open', function() {
  console.log('MongoDb connection opened.');
});

passport.serializeUser(auth.serializeUser);

passport.deserializeUser(auth.deserializeUser);

passport.use(auth.localStrategy);

passport.use(auth.facebookStrategy);

passport.use(auth.twitterStrategy);

passport.use(auth.googleStrategy);

app = express();

adminApp = require('./admin/app');

server = http.createServer(app);

app.set('views', './static');

app.set('view engine', 'jade');

app.use(require('prerender-node').set('prerenderToken', 'YOUR_TOKEN'));

app.use(logger('dev'));

app.use(compression());

app.use(bodyParser.json());

app.use(bodyParser.urlencoded({
  extended: false
}));

app.use(cookieParser());

app.use(session({
  secret: 'nerf this',
  resave: false,
  saveUninitialized: true,
  cookie: {},
  unset: 'destroy',
  store: new MongoStore({
    mongooseConnection: mongoose.connection,
    clear_interval: 604800
  })
}));

app.use(passport.initialize());

app.use(passport.session());

app.get('/auth/facebook', passport.authenticate('facebook'));

app.get('/auth/facebook/callback', passport.authenticate('facebook'), auth.facebookAuthCallback);

app.get('/auth/twitter', passport.authenticate('twitter'));

app.get('/auth/twitter/callback', passport.authenticate('twitter'), auth.twitterAuthCallback);

app.get('/auth/google', passport.authenticate('google', {
  scope: 'https://www.googleapis.com/auth/plus.login'
}));

app.get('/auth/google/callback', passport.authenticate('google', {
  scope: 'https://www.googleapis.com/auth/plus.login'
}), auth.googleAuthCallback);

app.get('*', function(req, res, next) {
  res.setHeader('X-XSS-Protection', '1; mode=block');
  res.removeHeader('server');
  res.removeHeader('x-powered-by');
  next();
});

app.get('/images/*', function(req, res, next) {
  if (req.url.indexOf('/images/') === 0 || req.url.indexOf('/stylesheets/') === 0) {
    res.setHeader('Cache-Control', 'public, max-age=2592000');
    res.setHeader('Expires', new Date(Date.now() + 2592000000).toUTCString());
  }
  next();
});

app.get('/favicon.ico', function(req, res, next) {
  res.setHeader('Cache-Control', 'public, max-age=2592000');
  res.setHeader('Expires', new Date(Date.now() + 2592000000).toUTCString());
  next();
});

routers = require('./routers/module');

app.use(routers.indexRouter);

app.use(routers.mainRouter);

app.use(routers.userRouter);

staticFiles = express["static"](path.join(__dirname, '../static'), {
  maxAge: 86400000
});

app.use(staticFiles);

app.use('/strength', staticFiles);

app.use('/strength/:sid', staticFiles);

app.use('/log', staticFiles);

app.use('/log/:lid', staticFiles);

app.use('/auth/facebook', staticFiles);

app.use('/auth', staticFiles);

app.use('/admin', adminApp);

app.get('*', function(req, res) {
  res.status(404);
  res.render('404.jade');
  res.end();
});

app.use(function(err, req, res) {
  console.log('ERROR', err);
  console.trace();
  res.render('error', {
    error: err
  });
});

port = 5000;

server.listen(port, function() {
  console.log('Express server listening on port %d in %s mode', port, app.get('env'));
});

module.exports = app;
