var MongoStore, app, bodyParser, cookieParser, db, express, favicon, http, logger, mongoose, passport, path, port, routers, server, session;

express = require('express');

path = require('path');

favicon = require('serve-favicon');

logger = require('morgan');

mongoose = require('mongoose');

bodyParser = require('body-parser');

cookieParser = require('cookie-parser');

session = require('express-session');

passport = require('passport');

http = require('http');

MongoStore = require('connect-mongo')(session);

require('coffee-script/register');

mongoose.connect('mongodb://localhost:27017/local');

db = mongoose.connection;

db.on('error', console.error.bind(console, 'connection error:'));

db.on('open', function() {
  console.log('MongoDb connection opened.');
});

require('./models/user')(mongoose);

require('./models/strength')(mongoose);

require('./models/slog')(mongoose);

app = express();

server = http.createServer(app);

app.set('views', './static');

app.set('view engine', 'jade');

app.use(logger('dev'));

app.use(bodyParser.json());

app.use(bodyParser.urlencoded({
  extended: false
}));

app.use(cookieParser());

app.use(session({
  secret: 'keyboard cat',
  resave: false,
  saveUninitialized: true,
  cookie: {},
  store: new MongoStore({
    mongooseConnection: mongoose.connection
  })
}));

app.use(express["static"](path.join(__dirname, '../static')));

app.use('/strength', express["static"](path.join(__dirname, '../static')));

app.use('/strength/:sid', express["static"](path.join(__dirname, '../static')));

app.use('/log', express["static"](path.join(__dirname, '../static')));

app.use('/log/:lid', express["static"](path.join(__dirname, '../static')));

routers = require('./routers/module');

app.use('/', routers.indexRouter);

app.use('/', routers.mainRouter);

app.use('/', routers.userRouter);

app.use(function(err, req, res, next) {
  console.log('ERROR', err);
  console.trace();
  res.render('error', {
    error: err
  });
});

app.use(function(err, req, res, next) {
  err = new Error('Not Found, Server Ended.');
  err.status = 404;
  next(err);
});

port = 5000;

server.listen(port, function() {
  console.log('Express server listening on port %d in %s mode', port, app.get('env'));
});

module.exports = app;
