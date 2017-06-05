var MongoStore, adminApp, app, async, auth, bodyParser, compression, config, cookieParser, db, express, favicon, http, i, len, logger, moment, mongoose, passport, path, ref, routers, server, session, url;

require('coffee-script/register');

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

mongoose.connect(config.databaseUrl, config.databaseOptions);

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

app.use(logger('dev'));

app.use(compression());

app.use(bodyParser.json({
  limit: '8mb'
}));

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

app.use(function(req, res, next) {
  res.setHeader('X-XSS-Protection', '1; mode=block');
  res.removeHeader('server');
  res.removeHeader('x-powered-by');
  next();
});

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

app.use('/admin', adminApp);

app.use(routers.indexRouter);

app.use(routers.mainRouter);

app.use(routers.userRouter);

ref = ['', '/cardio', '/cardio/:cid', '/strength', '/strength/:sid', '/log', '/log/:lid', '/admin'];
for (i = 0, len = ref.length; i < len; i++) {
  url = ref[i];
  app.use(url, function(req, res, next) {
    res.setHeader('Expires', new Date(Date.now() + 2592000000).toUTCString());
    next();
  }, express["static"](path.join(__dirname, '../static'), {
    maxAge: 86400000
  }));
}

app.get('*', function(req, res) {
  res.status(404);
  res.render('404.jade');
  res.end();
});

app.use(function(err, req, res) {
  console.trace();
  res.render('error', {
    error: err
  });
});

server.listen(config.port, function() {
  console.log('Express server listening on port %d in %s mode', config.port, app.get('env'));
});

module.exports = app;
