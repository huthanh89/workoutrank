var Facebook, FacebookStrategy, Google, GoogleStrategy, LocalStrategy, MongoStore, Twitter, TwitterStrategy, User, adminApp, app, async, bodyParser, compression, cookieParser, db, express, favicon, http, logger, mongoose, passport, path, port, routers, server, session, staticFiles;

require('coffee-script/register');

async = require('async');

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

LocalStrategy = require('passport-local').Strategy;

FacebookStrategy = require('passport-facebook').Strategy;

TwitterStrategy = require('passport-twitter').Strategy;

GoogleStrategy = require('passport-google-oauth').OAuth2Strategy;

mongoose.connect('mongodb://localhost:27017/local');

db = mongoose.connection;

db.on('error', console.error.bind(console, 'connection error:'));

db.on('open', function() {
  console.log('MongoDb connection opened.');
});

require('./models/user')(mongoose);

require('./models/strength')(mongoose);

require('./models/slog')(mongoose);

require('./models/wlog')(mongoose);

require('./models/schedule')(mongoose);

require('./models/feedback')(mongoose);

require('./models/token')(mongoose);

require('./models/facebook')(mongoose);

require('./models/twitter')(mongoose);

require('./models/google')(mongoose);

User = mongoose.model('user');

Facebook = mongoose.model('facebook');

Twitter = mongoose.model('twitter');

Google = mongoose.model('google');

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

passport.serializeUser(function(user, done) {
  done(null, user.id);
});

passport.deserializeUser(function(id, done) {
  return User.findOne({
    $or: [
      {
        _id: id
      }, {
        facebookID: id
      }, {
        twitterID: id
      }, {
        googleID: id
      }
    ]
  }).exec(function(err, user) {
    done(err, user);
  });
});

passport.use(new FacebookStrategy({
  clientID: '1588504301452640',
  clientSecret: '672cb532bbaf22b5a565cdf5e15893c3',
  callbackURL: '/auth/facebook/callback',
  profileFields: ['id', 'displayName', 'photos', 'email']
}, function(accessToken, refreshToken, profile, done) {
  async.waterfall([
    function(callback) {
      return Facebook.findOne({
        facebookID: profile.id
      }).exec(function(err, user) {
        if (err) {
          return callback(err);
        }
        return callback(null, user);
      });
    }, function(user, callback) {
      if (user) {
        return callback(null, user);
      }
      if (user === null) {
        Facebook.create({
          facebookID: profile.id,
          name: profile.displayName,
          accessToken: accessToken,
          refreshToken: refreshToken
        }, function(err, user) {
          if (err) {
            return callback(err);
          }
          return callback(null, user);
        });
      }
    }
  ], function(err, user) {
    return done(err, user);
  });
}));

passport.use(new LocalStrategy(function(username, password, callback) {
  User.findOne({
    username: username,
    provider: 'local'
  }, function(err, user) {
    if (err) {
      return callback(err);
    }
    if (!user) {
      return callback(null, false, {
        message: 'Incorrect username.'
      });
    }
    return user.validPassword(password, callback);
  });
}));

passport.use(new TwitterStrategy({
  consumerKey: 'FdE3OIEzPttU9Dw3Jf8xpAqPW',
  consumerSecret: 'ucZGlEOaDF8K7MIrYwz04biOD5JThbWk3kVvwFixCndKA2Upgo',
  callbackURL: '/auth/twitter/callback'
}, function(token, tokenSecret, profile, done) {
  async.waterfall([
    function(callback) {
      return Twitter.findOne({
        twitterID: profile.id
      }).exec(function(err, user) {
        if (err) {
          return callback(err);
        }
        return callback(null, user);
      });
    }, function(user, callback) {
      if (user) {
        return callback(null, user);
      }
      if (user === null) {
        Twitter.create({
          twitterID: profile.id,
          token: token,
          tokenSecret: tokenSecret
        }, function(err, user) {
          if (err) {
            return callback(err);
          }
          return callback(null, user);
        });
      }
    }
  ], function(err, user) {
    return done(err, user);
  });
}));

passport.use(new GoogleStrategy({
  clientID: '372505580779-p0ku93tjmq14n8lg5nv5et2uui8p8puh.apps.googleusercontent.com',
  clientSecret: 'Bo-8UYRGdX5NAkKYxgxvtdg5',
  callbackURL: '/auth/google/callback'
}, function(accessToken, refreshToken, profile, done) {
  async.waterfall([
    function(callback) {
      return Google.findOne({
        googleID: profile.id
      }).exec(function(err, user) {
        if (err) {
          return callback(err);
        }
        return callback(null, user);
      });
    }, function(user, callback) {
      if (user) {
        return callback(null, user);
      }
      if (user === null) {
        Google.create({
          googleID: profile.id,
          accessToken: accessToken,
          refreshToken: refreshToken
        }, function(err, user) {
          if (err) {
            return callback(err);
          }
          return callback(null, user);
        });
      }
    }
  ], function(err, user) {
    return done(err, user);
  });
}));

app.use(passport.initialize());

app.use(passport.session());

app.get('/auth/facebook', passport.authenticate('facebook'));

app.get('/auth/facebook/callback', passport.authenticate('facebook'), function(req, res) {
  async.waterfall([
    function(callback) {
      return User.findOne({
        facebookID: req.session.passport.user
      }).exec(function(err, user) {
        if (err) {
          return callback(err);
        }
        return callback(null, user);
      });
    }, function(user, callback) {
      if (user !== null) {
        return callback(null);
      }
      return User.create({
        facebookID: req.session.passport.user,
        provider: 'facebook'
      }, function(err, user) {
        if (err) {
          return callback(err);
        }
        return callback(null, user);
      });
    }
  ], function(err, user) {
    if (err) {
      console.log('ERROR', err);
      return res.status(404);
    } else {
      return res.redirect('/home');
    }
  });
});

app.get('/auth/twitter', passport.authenticate('twitter'));

app.get('/auth/twitter/callback', passport.authenticate('twitter'), function(req, res) {
  async.waterfall([
    function(callback) {
      return User.findOne({
        twitterID: req.session.passport.user
      }).exec(function(err, user) {
        if (err) {
          return callback(err);
        }
        return callback(null, user);
      });
    }, function(user, callback) {
      if (user !== null) {
        return callback(null);
      }
      return User.create({
        twitterID: req.session.passport.user,
        provider: 'twitter'
      }, function(err, user) {
        if (err) {
          return callback(err);
        }
        return callback(null, user);
      });
    }
  ], function(err, user) {
    if (err) {
      console.log('ERROR', err);
      return res.status(404);
    } else {
      return res.redirect('/home');
    }
  });
});

app.get('/auth/google', passport.authenticate('google', {
  scope: 'https://www.googleapis.com/auth/plus.login'
}));

app.get('/auth/google/callback', passport.authenticate('google', {
  scope: 'https://www.googleapis.com/auth/plus.login'
}), function(req, res) {
  async.waterfall([
    function(callback) {
      return User.findOne({
        googleID: req.session.passport.user
      }).exec(function(err, user) {
        if (err) {
          return callback(err);
        }
        return callback(null, user);
      });
    }, function(user, callback) {
      if (user !== null) {
        return callback(null);
      }
      return User.create({
        googleID: req.session.passport.user,
        provider: 'google'
      }, function(err, user) {
        if (err) {
          return callback(err);
        }
        return callback(null, user);
      });
    }
  ], function(err, user) {
    if (err) {
      console.log('ERROR', err);
      return res.status(404);
    } else {
      return res.redirect('/home');
    }
  });
});

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

routers = require('./routers/module');

app.use(routers.indexRouter);

app.use(routers.mainRouter);

app.use(routers.userRouter);

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

app.get(function(err, req, res, next) {
  err = new Error('Not Found, Server Ended.');
  err.status = 404;
  next(err);
});

port = 5000;

server.listen(port, function() {
  console.log('Express server listening on port %d in %s mode', port, app.get('env'));
});

module.exports = app;
