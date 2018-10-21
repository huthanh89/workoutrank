/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, { enumerable: true, get: getter });
/******/ 		}
/******/ 	};
/******/
/******/ 	// define __esModule on exports
/******/ 	__webpack_require__.r = function(exports) {
/******/ 		if(typeof Symbol !== 'undefined' && Symbol.toStringTag) {
/******/ 			Object.defineProperty(exports, Symbol.toStringTag, { value: 'Module' });
/******/ 		}
/******/ 		Object.defineProperty(exports, '__esModule', { value: true });
/******/ 	};
/******/
/******/ 	// create a fake namespace object
/******/ 	// mode & 1: value is a module id, require it
/******/ 	// mode & 2: merge all properties of value into the ns
/******/ 	// mode & 4: return value when already ns object
/******/ 	// mode & 8|1: behave like require
/******/ 	__webpack_require__.t = function(value, mode) {
/******/ 		if(mode & 1) value = __webpack_require__(value);
/******/ 		if(mode & 8) return value;
/******/ 		if((mode & 4) && typeof value === 'object' && value && value.__esModule) return value;
/******/ 		var ns = Object.create(null);
/******/ 		__webpack_require__.r(ns);
/******/ 		Object.defineProperty(ns, 'default', { enumerable: true, value: value });
/******/ 		if(mode & 2 && typeof value != 'string') for(var key in value) __webpack_require__.d(ns, key, function(key) { return value[key]; }.bind(null, key));
/******/ 		return ns;
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = "./src/server/app.coffee");
/******/ })
/************************************************************************/
/******/ ({

/***/ "./node_modules/webpack/buildin/module.js":
/*!***********************************!*\
  !*** (webpack)/buildin/module.js ***!
  \***********************************/
/*! no static exports found */
/***/ (function(module, exports) {

eval("module.exports = function(module) {\r\n\tif (!module.webpackPolyfill) {\r\n\t\tmodule.deprecate = function() {};\r\n\t\tmodule.paths = [];\r\n\t\t// module.parent = undefined by default\r\n\t\tif (!module.children) module.children = [];\r\n\t\tObject.defineProperty(module, \"loaded\", {\r\n\t\t\tenumerable: true,\r\n\t\t\tget: function() {\r\n\t\t\t\treturn module.l;\r\n\t\t\t}\r\n\t\t});\r\n\t\tObject.defineProperty(module, \"id\", {\r\n\t\t\tenumerable: true,\r\n\t\t\tget: function() {\r\n\t\t\t\treturn module.i;\r\n\t\t\t}\r\n\t\t});\r\n\t\tmodule.webpackPolyfill = 1;\r\n\t}\r\n\treturn module;\r\n};\r\n\n\n//# sourceURL=webpack:///(webpack)/buildin/module.js?");

/***/ }),

/***/ "./src/server/app.coffee":
/*!*******************************!*\
  !*** ./src/server/app.coffee ***!
  \*******************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

eval("//--------------------------------------------------------------\n// Register all models to mongoose object.\n//--------------------------------------------------------------\nvar MongoStore, app, async, auth, bodyParser, compression, config, cookieParser, db, express, favicon, logger, moment, mongoose, passport, path, routers, session;\n\n__webpack_require__(/*! ./models/facebook */ \"./src/server/models/facebook.coffee\");\n\n__webpack_require__(/*! ./models/feedback */ \"./src/server/models/feedback.coffee\");\n\n__webpack_require__(/*! ./models/google */ \"./src/server/models/google.coffee\");\n\n__webpack_require__(/*! ./models/schedule */ \"./src/server/models/schedule.coffee\");\n\n__webpack_require__(/*! ./models/strength */ \"./src/server/models/strength.coffee\");\n\n__webpack_require__(/*! ./models/slog */ \"./src/server/models/slog.coffee\");\n\n__webpack_require__(/*! ./models/cardio */ \"./src/server/models/cardio.coffee\");\n\n__webpack_require__(/*! ./models/clog */ \"./src/server/models/clog.coffee\");\n\n__webpack_require__(/*! ./models/token */ \"./src/server/models/token.coffee\");\n\n__webpack_require__(/*! ./models/twitter */ \"./src/server/models/twitter.coffee\");\n\n__webpack_require__(/*! ./models/user */ \"./src/server/models/user.coffee\");\n\n__webpack_require__(/*! ./models/wlog */ \"./src/server/models/wlog.coffee\");\n\n__webpack_require__(/*! ./models/image */ \"./src/server/models/image.coffee\");\n\n//--------------------------------------------------------------\n// Imports\n//--------------------------------------------------------------\nasync = __webpack_require__(/*! async */ \"async\");\n\nmoment = __webpack_require__(/*! moment */ \"moment\");\n\nexpress = __webpack_require__(/*! express */ \"express\");\n\npath = __webpack_require__(/*! path */ \"path\");\n\nfavicon = __webpack_require__(/*! serve-favicon */ \"serve-favicon\");\n\nlogger = __webpack_require__(/*! morgan */ \"morgan\");\n\nmongoose = __webpack_require__(/*! mongoose */ \"mongoose\");\n\nbodyParser = __webpack_require__(/*! body-parser */ \"body-parser\");\n\ncookieParser = __webpack_require__(/*! cookie-parser */ \"cookie-parser\");\n\nsession = __webpack_require__(/*! express-session */ \"express-session\");\n\ncompression = __webpack_require__(/*! compression */ \"compression\");\n\nMongoStore = __webpack_require__(/*! connect-mongo */ \"connect-mongo\")(session);\n\npassport = __webpack_require__(/*! passport */ \"passport\");\n\nauth = __webpack_require__(/*! ./auth */ \"./src/server/auth.coffee\");\n\nconfig = __webpack_require__(/*! ./config */ \"./src/server/config.coffee\");\n\nrouters = __webpack_require__(/*! ./routers/module */ \"./src/server/routers/module.coffee\");\n\n//--------------------------------------------------------------\n// Create Express App\n//--------------------------------------------------------------\napp = express();\n\n//--------------------------------------------------------------\n// APP configurations for headers etc.\n//--------------------------------------------------------------\n\n// Tell express to look for views in the following directory.\napp.set(\"views\", path.join(__dirname, \"/dist\"));\n\napp.set('view engine', 'html');\n\napp.use(bodyParser.json({\n  limit: '8mb'\n}));\n\napp.use(bodyParser.urlencoded({\n  extended: false\n}));\n\n// Able to read client's cookie.\napp.use(cookieParser());\n\n// Initialize session.\n// Session cookie will last for a week.\n// Remove session from data base after an hour (3600 secs) of expiration.\napp.use(session({\n  secret: 'nerf this',\n  resave: false,\n  saveUninitialized: true,\n  cookie: {},\n  unset: 'destroy',\n  store: new MongoStore({\n    mongooseConnection: mongoose.connection,\n    clear_interval: 604800\n  })\n}));\n\napp.use(function(req, res, next) {\n  res.setHeader('X-XSS-Protection', '1; mode=block');\n  res.removeHeader('server');\n  res.removeHeader('x-powered-by');\n  next();\n});\n\n//--------------------------------------------------------------\n// Configure and initialize passport.\n//--------------------------------------------------------------\npassport.serializeUser(auth.serializeUser);\n\npassport.deserializeUser(auth.deserializeUser);\n\npassport.use(auth.localStrategy);\n\npassport.use(auth.facebookStrategy);\n\npassport.use(auth.twitterStrategy);\n\npassport.use(auth.googleStrategy);\n\napp.use(passport.initialize());\n\napp.use(passport.session());\n\n//--------------------------------------------------------------\n// Database Connection\n//--------------------------------------------------------------\n\n// Handle deprecated \"mpromise\" library warning.\nmongoose.Promise = global.Promise;\n\n// Connect to Database.\nmongoose.connect(config.databaseUrl, {\n  useNewUrlParser: true,\n  autoIndex: false\n});\n\ndb = mongoose.connection;\n\ndb.on('error', console.error.bind(console, 'MongoDB Connection Error:'));\n\ndb.on('open', function() {\n  console.log('MongoDb connection opened');\n});\n\n//--------------------------------------------------------------\n// Router level Middlewares\n//--------------------------------------------------------------\napp.use(routers.indexRouter);\n\napp.use(routers.mainRouter);\n\napp.use(routers.userRouter);\n\n//--------------------------------------------------------------\n// Listen on port\n//--------------------------------------------------------------\napp.listen(5000, () => {\n  return console.log('Math App listening on port 5000');\n});\n\n//--------------------------------------------------------------\n// Exports\n//--------------------------------------------------------------\nmodule.exports = app;\n\n//--------------------------------------------------------------\n\n\n//# sourceURL=webpack:///./src/server/app.coffee?");

/***/ }),

/***/ "./src/server/auth.coffee":
/*!********************************!*\
  !*** ./src/server/auth.coffee ***!
  \********************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

eval("//-------------------------------------------------------------------------------\n// Imports\n//-------------------------------------------------------------------------------\nvar Facebook, FacebookStrategy, Google, GoogleStrategy, LocalStrategy, Twitter, TwitterStrategy, User, _, async, moment, mongoose, passport;\n\n_ = __webpack_require__(/*! lodash */ \"lodash\");\n\nmoment = __webpack_require__(/*! moment */ \"moment\");\n\nasync = __webpack_require__(/*! async */ \"async\");\n\nmongoose = __webpack_require__(/*! mongoose */ \"mongoose\");\n\npassport = __webpack_require__(/*! passport */ \"passport\");\n\nLocalStrategy = __webpack_require__(/*! passport-local */ \"passport-local\").Strategy;\n\nFacebookStrategy = __webpack_require__(/*! passport-facebook */ \"passport-facebook\").Strategy;\n\nTwitterStrategy = __webpack_require__(/*! passport-twitter */ \"passport-twitter\").Strategy;\n\nGoogleStrategy = __webpack_require__(/*! passport-google-oauth */ \"passport-google-oauth\").OAuth2Strategy;\n\n//-------------------------------------------------------------------------------\n// Import Models\n//-------------------------------------------------------------------------------\nUser = mongoose.model('user');\n\nFacebook = mongoose.model('facebook');\n\nGoogle = mongoose.model('google');\n\nTwitter = mongoose.model('twitter');\n\n//-------------------------------------------------------------------------------\n// Exports\n//-------------------------------------------------------------------------------\n\n// Store id in session. Parameter 'user' is passed in from strategy.\n// After serializeUser, we'll go to the auth/callback handler.\nexports.serializeUser = function(profileID, done) {\n  return done(null, profileID);\n};\n\n// Called to find user with given id.\nexports.deserializeUser = function(id, done) {\n  return User.findOne({\n    _id: id\n  }).exec(function(err, user) {\n    done(err, user);\n  });\n};\n\nexports.localStrategy = new LocalStrategy(function(username, password, callback) {\n  User.findOneAndUpdate({\n    username: username,\n    provider: 'local'\n  }, {\n    lastlogin: moment()\n  }, function(err, user) {\n    if (err) {\n      return callback(err);\n    }\n    if (!user) {\n      return callback(null, false, {\n        message: 'Incorrect username.'\n      });\n    }\n    return user.validPassword(password, callback);\n  });\n});\n\n// Create an entry for facebook\n// Instead of using facebook id, we make and use our own.\n// and send that _id to be serialize in the session.\nexports.facebookStrategy = new FacebookStrategy({\n  clientID: '1588504301452640',\n  clientSecret: '672cb532bbaf22b5a565cdf5e15893c3',\n  callbackURL: '/auth/facebook/callback',\n  profileFields: ['id', 'displayName', 'photos', 'email']\n}, function(accessToken, refreshToken, profile, done) {\n  async.waterfall([\n    function(callback) {\n      return Facebook.findOne({\n        facebookID: profile.id\n      }).exec(function(err,\n    facebook) {\n        if (err) {\n          return callback(err);\n        }\n        return callback(null,\n    facebook);\n      });\n    },\n    function(facebook,\n    callback) {\n      if (facebook) {\n        return callback(null,\n    facebook);\n      }\n      if (facebook === null) {\n        Facebook.create({\n          facebookID: profile.id,\n          name: profile.displayName,\n          accessToken: accessToken,\n          refreshToken: refreshToken\n        },\n    function(err,\n    facebook) {\n          if (err) {\n            return callback(err);\n          }\n          return callback(null,\n    facebook);\n        });\n      }\n    },\n    function(facebook,\n    callback) {\n      return User.findOne({\n        facebookID: facebook._id\n      }).exec(function(err,\n    user) {\n        if (err) {\n          return callback(err);\n        }\n        return callback(null,\n    facebook,\n    user);\n      });\n    },\n    function(facebook,\n    user,\n    callback) {\n      if (user !== null) {\n        return callback(null,\n    user);\n      }\n      return User.create({\n        facebookID: facebook._id,\n        provider: 'facebook'\n      },\n    function(err,\n    user) {\n        if (err) {\n          return callback(err);\n        }\n        return callback(null,\n    user);\n      });\n    },\n    function(user,\n    callback) {\n      // Update lastlogin time.\n      return User.findOneAndUpdate({\n        _id: user._id\n      },\n    {\n        lastlogin: moment()\n      },\n    function(err,\n    user) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    user);\n      });\n    }\n  ], function(err, user) {\n    return done(err, user._id);\n  });\n});\n\nexports.twitterStrategy = new TwitterStrategy({\n  consumerKey: 'FdE3OIEzPttU9Dw3Jf8xpAqPW',\n  consumerSecret: 'ucZGlEOaDF8K7MIrYwz04biOD5JThbWk3kVvwFixCndKA2Upgo',\n  callbackURL: '/auth/twitter/callback'\n}, function(token, tokenSecret, profile, done) {\n  async.waterfall([\n    function(callback) {\n      return Twitter.findOne({\n        twitterID: profile.id\n      }).exec(function(err,\n    user) {\n        if (err) {\n          return callback(err);\n        }\n        return callback(null,\n    user);\n      });\n    },\n    function(twitter,\n    callback) {\n      if (twitter) {\n        return callback(null,\n    twitter);\n      }\n      if (twitter === null) {\n        Twitter.create({\n          twitterID: profile.id,\n          token: token,\n          tokenSecret: tokenSecret\n        },\n    function(err,\n    twitter) {\n          if (err) {\n            return callback(err);\n          }\n          return callback(null,\n    twitter);\n        });\n      }\n    },\n    function(twitter,\n    callback) {\n      return User.findOne({\n        twitterID: twitter._id\n      }).exec(function(err,\n    user) {\n        if (err) {\n          return callback(err);\n        }\n        return callback(null,\n    twitter,\n    user);\n      });\n    },\n    function(twitter,\n    user,\n    callback) {\n      if (user !== null) {\n        return callback(null,\n    user);\n      }\n      return User.create({\n        twitterID: twitter._id,\n        provider: 'twitter'\n      },\n    function(err,\n    user) {\n        if (err) {\n          return callback(err);\n        }\n        return callback(null,\n    user);\n      });\n    },\n    function(user,\n    callback) {\n      // Update lastlogin time.\n      return User.findOneAndUpdate({\n        _id: user._id\n      },\n    {\n        lastlogin: moment()\n      },\n    function(err,\n    user) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    user);\n      });\n    }\n  ], function(err, user) {\n    return done(err, user._id);\n  });\n});\n\nexports.googleStrategy = new GoogleStrategy({\n  clientID: '372505580779-p0ku93tjmq14n8lg5nv5et2uui8p8puh.apps.googleusercontent.com',\n  clientSecret: 'Bo-8UYRGdX5NAkKYxgxvtdg5',\n  callbackURL: '/auth/google/callback'\n}, function(accessToken, refreshToken, profile, done) {\n  async.waterfall([\n    function(callback) {\n      return Google.findOne({\n        googleID: profile.id\n      }).exec(function(err,\n    google) {\n        if (err) {\n          return callback(err);\n        }\n        return callback(null,\n    google);\n      });\n    },\n    function(google,\n    callback) {\n      if (google) {\n        return callback(null,\n    google);\n      }\n      if (google === null) {\n        Google.create({\n          googleID: profile.id,\n          accessToken: accessToken,\n          refreshToken: refreshToken\n        },\n    function(err,\n    google) {\n          if (err) {\n            return callback(err);\n          }\n          return callback(null,\n    google);\n        });\n      }\n    },\n    function(google,\n    callback) {\n      return User.findOne({\n        googleID: google._id\n      }).exec(function(err,\n    user) {\n        if (err) {\n          return callback(err);\n        }\n        return callback(null,\n    google,\n    user);\n      });\n    },\n    function(google,\n    user,\n    callback) {\n      if (user !== null) {\n        return callback(null,\n    user);\n      }\n      return User.create({\n        googleID: google._id,\n        provider: 'google'\n      },\n    function(err,\n    user) {\n        if (err) {\n          return callback(err);\n        }\n        return callback(null,\n    user);\n      });\n    },\n    function(user,\n    callback) {\n      // Update lastlogin time.\n      return User.findOneAndUpdate({\n        _id: user._id\n      },\n    {\n        lastlogin: moment()\n      },\n    function(err,\n    user) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    user);\n      });\n    }\n  ], function(err, user) {\n    return done(err, user._id);\n  });\n});\n\nexports.facebookAuthCallback = function(req, res) {\n  res.redirect('/home');\n};\n\nexports.twitterAuthCallback = function(req, res) {\n  res.redirect('/home');\n};\n\nexports.googleAuthCallback = function(req, res) {\n  res.redirect('/home');\n};\n\n//-------------------------------------------------------------------------------\n\n\n//# sourceURL=webpack:///./src/server/auth.coffee?");

/***/ }),

/***/ "./src/server/config.coffee":
/*!**********************************!*\
  !*** ./src/server/config.coffee ***!
  \**********************************/
/*! no static exports found */
/***/ (function(module, exports) {

eval("//--------------------------------------------------------------\n// Database Configurations\n//--------------------------------------------------------------\n\n// Production variable.\nvar databaseOptions, databaseUrl, port, production;\n\nproduction = false;\n\n// Port to host app.\nport = 5000;\n\n// MongoDB url\ndatabaseUrl = 'mongodb://localhost:27017/local';\n\ndatabaseOptions = {\n  user: '',\n  pass: '',\n  auth: {\n    authdb: ''\n  }\n};\n\n// MongoDB auth with username and password.\nif (production) {\n  databaseOptions = {\n    user: 'admin',\n    pass: '1234',\n    auth: {\n      authdb: 'admin'\n    }\n  };\n}\n\n//--------------------------------------------------------------\n// Exports\n//--------------------------------------------------------------\nexports.port = port;\n\nexports.databaseUrl = databaseUrl;\n\nexports.databaseOptions = databaseOptions;\n\n//--------------------------------------------------------------\n\n\n//# sourceURL=webpack:///./src/server/config.coffee?");

/***/ }),

/***/ "./src/server/middleware.coffee":
/*!**************************************!*\
  !*** ./src/server/middleware.coffee ***!
  \**************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

eval("//-------------------------------------------------------------------------------\n// Imports\n//-------------------------------------------------------------------------------\nvar _;\n\n_ = __webpack_require__(/*! lodash */ \"lodash\");\n\n//-------------------------------------------------------------------------------\n// Exports\n//-------------------------------------------------------------------------------\nmodule.exports.isAuthenticated = function(req, res, next) {\n  /*\n    if req.xhr and not req.isAuthenticated()\n      res\n      .status 401\n      .json   'Not logged in'\n\n    else if not req.isAuthenticated()\n      res.redirect '/login'\n\n    else\n      next()\n  */\n  next();\n};\n\n//-------------------------------------------------------------------------------\n\n\n//# sourceURL=webpack:///./src/server/middleware.coffee?");

/***/ }),

/***/ "./src/server/models/cardio.coffee":
/*!*****************************************!*\
  !*** ./src/server/models/cardio.coffee ***!
  \*****************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

eval("//-------------------------------------------------------------------------------\n// Imports\n//-------------------------------------------------------------------------------\nvar model, mongoose, schema;\n\nmongoose = __webpack_require__(/*! mongoose */ \"mongoose\");\n\n//-------------------------------------------------------------------------------\n// CConf Schema\n//-------------------------------------------------------------------------------\nschema = mongoose.Schema({\n  user: {\n    type: mongoose.Schema.ObjectId,\n    required: true\n  },\n  date: {\n    type: Date,\n    required: true\n  },\n  name: {\n    type: String,\n    required: true\n  },\n  note: {\n    type: String\n  }\n}, {\n  collection: 'cardio'\n});\n\n//-------------------------------------------------------------------------------\n// Model Registration\n//-------------------------------------------------------------------------------\nmodel = mongoose.model('cardio', schema);\n\n//-------------------------------------------------------------------------------\n// Exports\n//-------------------------------------------------------------------------------\nmodule.exports = model;\n\n//-------------------------------------------------------------------------------\n\n\n//# sourceURL=webpack:///./src/server/models/cardio.coffee?");

/***/ }),

/***/ "./src/server/models/clog.coffee":
/*!***************************************!*\
  !*** ./src/server/models/clog.coffee ***!
  \***************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

eval("//-------------------------------------------------------------------------------\n// Imports\n//-------------------------------------------------------------------------------\nvar model, mongoose, schema;\n\nmongoose = __webpack_require__(/*! mongoose */ \"mongoose\");\n\n//-------------------------------------------------------------------------------\n// CLog Schema\n//-------------------------------------------------------------------------------\nschema = mongoose.Schema({\n  created: {\n    type: Date,\n    required: true\n  },\n  note: {\n    type: String\n  },\n  duration: {\n    type: Number\n  },\n  intensity: {\n    type: Number\n  },\n  speed: {\n    type: Number\n  },\n  exerciseID: {\n    type: mongoose.Schema.ObjectId,\n    required: true\n  },\n  user: {\n    type: mongoose.Schema.ObjectId,\n    required: true\n  }\n}, {\n  collection: 'clog'\n});\n\n//-------------------------------------------------------------------------------\n// Model Registration\n//-------------------------------------------------------------------------------\nmodel = mongoose.model('clog', schema);\n\n//-------------------------------------------------------------------------------\n// Exports\n//-------------------------------------------------------------------------------\nmodule.exports = model;\n\n//-------------------------------------------------------------------------------\n\n\n//# sourceURL=webpack:///./src/server/models/clog.coffee?");

/***/ }),

/***/ "./src/server/models/facebook.coffee":
/*!*******************************************!*\
  !*** ./src/server/models/facebook.coffee ***!
  \*******************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

eval("//-------------------------------------------------------------------------------\n// Imports\n//-------------------------------------------------------------------------------\nvar _, async, crypto, model, moment, mongoose, schema;\n\n_ = __webpack_require__(/*! lodash */ \"lodash\");\n\nasync = __webpack_require__(/*! async */ \"async\");\n\nmoment = __webpack_require__(/*! moment */ \"moment\");\n\nmongoose = __webpack_require__(/*! mongoose */ \"mongoose\");\n\ncrypto = __webpack_require__(/*! crypto */ \"crypto\");\n\n//-------------------------------------------------------------------------------\n// Facebook Schema\n//-------------------------------------------------------------------------------\nschema = mongoose.Schema({\n  facebookID: {\n    type: String,\n    unique: true\n  },\n  name: {\n    type: String\n  },\n  accessToken: {\n    type: String\n  },\n  refreshToken: {\n    type: String\n  }\n}, {\n  collection: 'facebook'\n});\n\n//-------------------------------------------------------------------------------\n// Model Registration\n//   In order to call 'Facebook' model from mongoose object.\n//-------------------------------------------------------------------------------\nmodel = mongoose.model('facebook', schema);\n\n//-------------------------------------------------------------------------------\n// Exports\n//-------------------------------------------------------------------------------\nmodule.exports = model;\n\n//-------------------------------------------------------------------------------\n\n\n//# sourceURL=webpack:///./src/server/models/facebook.coffee?");

/***/ }),

/***/ "./src/server/models/feedback.coffee":
/*!*******************************************!*\
  !*** ./src/server/models/feedback.coffee ***!
  \*******************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

eval("//-------------------------------------------------------------------------------\n// Imports\n//-------------------------------------------------------------------------------\nvar model, mongoose, schema;\n\nmongoose = __webpack_require__(/*! mongoose */ \"mongoose\");\n\n//-------------------------------------------------------------------------------\n// Feedback Schema\n//-------------------------------------------------------------------------------\nschema = mongoose.Schema({\n  date: {\n    type: Date\n  },\n  type: {\n    type: Number\n  },\n  title: {\n    type: String\n  },\n  text: {\n    type: String\n  }\n}, {\n  collection: 'feedback'\n});\n\n//-------------------------------------------------------------------------------\n// Model Registration\n//-------------------------------------------------------------------------------\nmodel = mongoose.model('feedback', schema);\n\n//-------------------------------------------------------------------------------\n// Exports\n//-------------------------------------------------------------------------------\nmodule.exports = model;\n\n//-------------------------------------------------------------------------------\n\n\n//# sourceURL=webpack:///./src/server/models/feedback.coffee?");

/***/ }),

/***/ "./src/server/models/google.coffee":
/*!*****************************************!*\
  !*** ./src/server/models/google.coffee ***!
  \*****************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

eval("//-------------------------------------------------------------------------------\n// Imports\n//-------------------------------------------------------------------------------\nvar model, mongoose, schema;\n\nmongoose = __webpack_require__(/*! mongoose */ \"mongoose\");\n\n//-------------------------------------------------------------------------------\n// Google Schema\n//-------------------------------------------------------------------------------\nschema = mongoose.Schema({\n  googleID: {\n    type: String,\n    unique: true\n  },\n  accessToken: {\n    type: String\n  },\n  refreshToken: {\n    type: String\n  }\n}, {\n  collection: 'google'\n});\n\n//-------------------------------------------------------------------------------\n// Model Registration\n//-------------------------------------------------------------------------------\nmodel = mongoose.model('google', schema);\n\n//-------------------------------------------------------------------------------\n// Exports\n//-------------------------------------------------------------------------------\nmodule.exports = model;\n\n//-------------------------------------------------------------------------------\n\n\n//# sourceURL=webpack:///./src/server/models/google.coffee?");

/***/ }),

/***/ "./src/server/models/image.coffee":
/*!****************************************!*\
  !*** ./src/server/models/image.coffee ***!
  \****************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

eval("//-------------------------------------------------------------------------------\n// Imports\n//-------------------------------------------------------------------------------\nvar async, model, moment, mongoose, schema;\n\nasync = __webpack_require__(/*! async */ \"async\");\n\nmoment = __webpack_require__(/*! moment */ \"moment\");\n\nmongoose = __webpack_require__(/*! mongoose */ \"mongoose\");\n\n//-------------------------------------------------------------------------------\n// Image Schema\n//-------------------------------------------------------------------------------\nschema = mongoose.Schema({\n  uploadDate: {\n    type: Date,\n    required: true\n  },\n  lastModified: {\n    type: Number,\n    required: true\n  },\n  lastModifiedDate: {\n    type: Date,\n    required: true\n  },\n  name: {\n    type: String,\n    required: true\n  },\n  size: {\n    type: Number,\n    required: true\n  },\n  imageType: {\n    type: String,\n    required: true\n  },\n  type: {\n    type: String,\n    required: true\n  },\n  data: {\n    type: String,\n    required: true\n  },\n  user: {\n    type: mongoose.Schema.ObjectId,\n    required: true\n  }\n}, {\n  collection: 'image'\n});\n\n//-------------------------------------------------------------------------------\n// Model Registration\n\n// Now you can access model from mongoose object instead of need to require.\n//-------------------------------------------------------------------------------\nmodel = mongoose.model('image', schema);\n\n//-------------------------------------------------------------------------------\n// Exports\n//-------------------------------------------------------------------------------\nmodule.exports = model;\n\n//-------------------------------------------------------------------------------\n\n\n//# sourceURL=webpack:///./src/server/models/image.coffee?");

/***/ }),

/***/ "./src/server/models/schedule.coffee":
/*!*******************************************!*\
  !*** ./src/server/models/schedule.coffee ***!
  \*******************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

eval("//-------------------------------------------------------------------------------\n// Imports\n//-------------------------------------------------------------------------------\nvar model, mongoose, schema;\n\nmongoose = __webpack_require__(/*! mongoose */ \"mongoose\");\n\n//-------------------------------------------------------------------------------\n// Schedule Schema\n//-------------------------------------------------------------------------------\nschema = mongoose.Schema({\n  user: {\n    type: mongoose.Schema.ObjectId,\n    required: true\n  },\n  date: {\n    type: Date,\n    required: true\n  },\n  sunday: {\n    type: [Number]\n  },\n  monday: {\n    type: [Number]\n  },\n  tuesday: {\n    type: [Number]\n  },\n  wednesday: {\n    type: [Number]\n  },\n  thursday: {\n    type: [Number]\n  },\n  friday: {\n    type: [Number]\n  },\n  saturday: {\n    type: [Number]\n  }\n}, {\n  collection: 'schedule'\n});\n\n//-------------------------------------------------------------------------------\n// Model Registration\n//-------------------------------------------------------------------------------\nmodel = mongoose.model('schedule', schema);\n\n//-------------------------------------------------------------------------------\n// Exports\n//-------------------------------------------------------------------------------\nmodule.exports = model;\n\n//-------------------------------------------------------------------------------\n\n\n//# sourceURL=webpack:///./src/server/models/schedule.coffee?");

/***/ }),

/***/ "./src/server/models/slog.coffee":
/*!***************************************!*\
  !*** ./src/server/models/slog.coffee ***!
  \***************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

eval("//-------------------------------------------------------------------------------\n// Imports\n//-------------------------------------------------------------------------------\nvar model, mongoose, schema;\n\nmongoose = __webpack_require__(/*! mongoose */ \"mongoose\");\n\n//-------------------------------------------------------------------------------\n// SLog Schema\n//-------------------------------------------------------------------------------\nschema = mongoose.Schema({\n  date: {\n    type: Date,\n    required: true\n  },\n  note: {\n    type: String\n  },\n  rep: {\n    type: Number,\n    required: true\n  },\n  weight: {\n    type: Number,\n    required: true\n  },\n  exercise: {\n    type: mongoose.Schema.ObjectId,\n    required: true\n  },\n  user: {\n    type: mongoose.Schema.ObjectId,\n    required: true\n  }\n}, {\n  collection: 'slog'\n});\n\n//-------------------------------------------------------------------------------\n// Model Registration\n//-------------------------------------------------------------------------------\nmodel = mongoose.model('slog', schema);\n\n//-------------------------------------------------------------------------------\n// Exports\n//-------------------------------------------------------------------------------\nmodule.exports = model;\n\n//-------------------------------------------------------------------------------\n\n\n//# sourceURL=webpack:///./src/server/models/slog.coffee?");

/***/ }),

/***/ "./src/server/models/strength.coffee":
/*!*******************************************!*\
  !*** ./src/server/models/strength.coffee ***!
  \*******************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

eval("//-------------------------------------------------------------------------------\n// Imports\n//-------------------------------------------------------------------------------\nvar model, mongoose, schema;\n\nmongoose = __webpack_require__(/*! mongoose */ \"mongoose\");\n\n//-------------------------------------------------------------------------------\n// SConf Schema\n//-------------------------------------------------------------------------------\nschema = mongoose.Schema({\n  user: {\n    type: mongoose.Schema.ObjectId,\n    required: true\n  },\n  date: {\n    type: Date,\n    required: true\n  },\n  name: {\n    type: String,\n    required: true\n  },\n  muscle: {\n    type: [Number]\n  },\n  body: {\n    type: Boolean,\n    required: true\n  },\n  note: {\n    type: String\n  }\n}, {\n  collection: 'strength'\n});\n\n//-------------------------------------------------------------------------------\n// Model Registration\n//-------------------------------------------------------------------------------\nmodel = mongoose.model('strength', schema);\n\n//-------------------------------------------------------------------------------\n// Exports\n//-------------------------------------------------------------------------------\nmodule.exports = model;\n\n//-------------------------------------------------------------------------------\n\n\n//# sourceURL=webpack:///./src/server/models/strength.coffee?");

/***/ }),

/***/ "./src/server/models/token.coffee":
/*!****************************************!*\
  !*** ./src/server/models/token.coffee ***!
  \****************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

eval("//-------------------------------------------------------------------------------\n// Imports\n//-------------------------------------------------------------------------------\nvar model, mongoose, schema;\n\nmongoose = __webpack_require__(/*! mongoose */ \"mongoose\");\n\n//-------------------------------------------------------------------------------\n// Token Schema\n//-------------------------------------------------------------------------------\nschema = mongoose.Schema({\n  date: {\n    type: Date,\n    required: true\n  },\n  token: {\n    type: String,\n    required: true\n  },\n  user: {\n    type: String,\n    required: true\n  }\n}, {\n  collection: 'token'\n});\n\n//-------------------------------------------------------------------------------\n// Model Registration\n//-------------------------------------------------------------------------------\nmodel = mongoose.model('token', schema);\n\n//-------------------------------------------------------------------------------\n// Exports\n//-------------------------------------------------------------------------------\nmodule.exports = model;\n\n//-------------------------------------------------------------------------------\n\n\n//# sourceURL=webpack:///./src/server/models/token.coffee?");

/***/ }),

/***/ "./src/server/models/twitter.coffee":
/*!******************************************!*\
  !*** ./src/server/models/twitter.coffee ***!
  \******************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

eval("//-------------------------------------------------------------------------------\n// Imports\n//-------------------------------------------------------------------------------\nvar model, mongoose, schema;\n\nmongoose = __webpack_require__(/*! mongoose */ \"mongoose\");\n\n//-------------------------------------------------------------------------------\n// Twitter Schema\n//-------------------------------------------------------------------------------\nschema = mongoose.Schema({\n  twitterID: {\n    type: String,\n    unique: true\n  },\n  token: {\n    type: String\n  },\n  tokenSecret: {\n    type: String\n  }\n}, {\n  collection: 'twitter'\n});\n\n//-------------------------------------------------------------------------------\n// Model Registration\n//-------------------------------------------------------------------------------\nmodel = mongoose.model('twitter', schema);\n\n//-------------------------------------------------------------------------------\n// Exports\n//-------------------------------------------------------------------------------\nmodule.exports = model;\n\n//-------------------------------------------------------------------------------\n\n\n//# sourceURL=webpack:///./src/server/models/twitter.coffee?");

/***/ }),

/***/ "./src/server/models/user.coffee":
/*!***************************************!*\
  !*** ./src/server/models/user.coffee ***!
  \***************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

eval("//-------------------------------------------------------------------------------\n// Imports\n//-------------------------------------------------------------------------------\nvar _, async, crypto, model, moment, mongoose, schema;\n\n_ = __webpack_require__(/*! lodash */ \"lodash\");\n\nasync = __webpack_require__(/*! async */ \"async\");\n\nmoment = __webpack_require__(/*! moment */ \"moment\");\n\nmongoose = __webpack_require__(/*! mongoose */ \"mongoose\");\n\ncrypto = __webpack_require__(/*! crypto */ \"crypto\");\n\n//-------------------------------------------------------------------------------\n// User Schema\n//-------------------------------------------------------------------------------\nschema = mongoose.Schema({\n  algorithm: {\n    type: String\n  },\n  rounds: {\n    type: Number\n  },\n  salt: {\n    type: String\n  },\n  key: {\n    type: String\n  },\n  email: {\n    type: String\n  },\n  username: {\n    type: String\n  },\n  facebookID: {\n    type: String\n  },\n  twitterID: {\n    type: String\n  },\n  googleID: {\n    type: String\n  },\n  provider: {\n    type: String\n  },\n  created: {\n    type: Date\n  },\n  auth: {\n    type: Number\n  },\n  lastlogin: {\n    type: Date\n  },\n  firstname: {\n    type: String\n  },\n  lastname: {\n    type: String\n  },\n  birthday: {\n    type: Date\n  },\n  height: {\n    type: Number\n  },\n  weight: {\n    type: Number\n  },\n  gender: {\n    type: Number\n  },\n  displayName: {\n    type: String\n  }\n}, {\n  collection: 'user'\n});\n\n//-------------------------------------------------------------------------------\n// Methods\n//-------------------------------------------------------------------------------\n\n// Return public fields only.\nschema.methods.getPublicFields = function() {\n  return {\n    _id: this._id,\n    email: this.email,\n    username: this.username,\n    firstname: this.firstname,\n    lastname: this.lastname,\n    height: this.height,\n    weight: this.weight,\n    gender: this.gender,\n    auth: this.auth,\n    birthday: this.birthday,\n    lastlogin: this.lastlogin,\n    provider: this.provider\n  };\n};\n\nschema.methods.validPassword = function(password, callback) {\n  crypto.pbkdf2(password, this.salt, this.rounds, 32, this.algorithm, (err, key) => {\n    if (this.key === key.toString('hex')) {\n      return callback(null, this._id);\n    } else {\n      return callback(null, false, {\n        message: 'Incorrect password.'\n      });\n    }\n  });\n};\n\n//-------------------------------------------------------------------------------\n// Model Registration\n\n// Now you can access model from mongoose object instead of need to require.\n//-------------------------------------------------------------------------------\nmodel = mongoose.model('user', schema);\n\n//-------------------------------------------------------------------------------\n// Exports\n//-------------------------------------------------------------------------------\nmodule.exports = model;\n\n//-------------------------------------------------------------------------------\n\n\n//# sourceURL=webpack:///./src/server/models/user.coffee?");

/***/ }),

/***/ "./src/server/models/wlog.coffee":
/*!***************************************!*\
  !*** ./src/server/models/wlog.coffee ***!
  \***************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

eval("//-------------------------------------------------------------------------------\n// Imports\n//-------------------------------------------------------------------------------\nvar model, mongoose, schema;\n\nmongoose = __webpack_require__(/*! mongoose */ \"mongoose\");\n\n//-------------------------------------------------------------------------------\n// WLog Schema\n//-------------------------------------------------------------------------------\nschema = mongoose.Schema({\n  date: {\n    type: Date,\n    required: true\n  },\n  weight: {\n    type: Number,\n    required: true\n  },\n  user: {\n    type: mongoose.Schema.ObjectId,\n    required: true\n  },\n  note: {\n    type: String\n  }\n}, {\n  collection: 'wlog'\n});\n\n//-------------------------------------------------------------------------------\n// Model Registration\n//-------------------------------------------------------------------------------\nmodel = mongoose.model('wlog', schema);\n\n//-------------------------------------------------------------------------------\n// Exports\n//-------------------------------------------------------------------------------\nmodule.exports = model;\n\n//-------------------------------------------------------------------------------\n\n\n//# sourceURL=webpack:///./src/server/models/wlog.coffee?");

/***/ }),

/***/ "./src/server/routers/error.coffee":
/*!*****************************************!*\
  !*** ./src/server/routers/error.coffee ***!
  \*****************************************/
/*! no static exports found */
/***/ (function(module, exports) {

eval("//-------------------------------------------------------------------------------\n// Base Error class\n//-------------------------------------------------------------------------------\nvar BadRequest, Err, Forbidden, NotFound, Unauthorized;\n\nErr = class Err extends Error {\n  constructor(options) {\n    super(options);\n    if (options != null ? options.status : void 0) {\n      this.status = options.status;\n    }\n    if (options != null ? options.statusText : void 0) {\n      this.statusText = options.statusText;\n    }\n    if (options != null ? options.responseText : void 0) {\n      this.responseText = options.responseText;\n    }\n  }\n\n};\n\nBadRequest = (function() {\n  //-------------------------------------------------------------------------------\n  // HTTP Response code\n  //-------------------------------------------------------------------------------\n  class BadRequest extends Err {};\n\n  BadRequest.prototype.status = 400;\n\n  BadRequest.prototype.statusText = 'Bad Request';\n\n  BadRequest.prototype.responseText = 'Cannot not process the request due to an apparent client error.';\n\n  return BadRequest;\n\n}).call(this);\n\nUnauthorized = (function() {\n  class Unauthorized extends Err {};\n\n  Unauthorized.prototype.status = 401;\n\n  Unauthorized.prototype.statusText = 'Unauthorized';\n\n  Unauthorized.prototype.responseText = 'User does not have the necessary credentials.';\n\n  return Unauthorized;\n\n}).call(this);\n\nForbidden = (function() {\n  class Forbidden extends Err {};\n\n  Forbidden.prototype.status = 403;\n\n  Forbidden.prototype.statusText = 'Forbidden';\n\n  Forbidden.prototype.responseText = 'User does not have the necessary permissions for the resource.';\n\n  return Forbidden;\n\n}).call(this);\n\nNotFound = (function() {\n  class NotFound extends Err {};\n\n  NotFound.prototype.status = 404;\n\n  NotFound.prototype.statusText = 'Not Found';\n\n  NotFound.prototype.responseText = 'The requested resource could not be found.';\n\n  return NotFound;\n\n}).call(this);\n\n//-------------------------------------------------------------------------------\n// Exports\n//-------------------------------------------------------------------------------\nmodule.exports.BadRequest = BadRequest;\n\nmodule.exports.Unauthorized = Unauthorized;\n\nmodule.exports.Forbidden = Forbidden;\n\nmodule.exports.NotFound = NotFound;\n\n//-------------------------------------------------------------------------------\n\n\n//# sourceURL=webpack:///./src/server/routers/error.coffee?");

/***/ }),

/***/ "./src/server/routers/index/feedback/module.coffee":
/*!*********************************************************!*\
  !*** ./src/server/routers/index/feedback/module.coffee ***!
  \*********************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

eval("//-------------------------------------------------------------------------------\n// Imports\n//-------------------------------------------------------------------------------\nvar Feedback, Validate, async, moment, mongoose, sanitize, schema;\n\nmoment = __webpack_require__(/*! moment */ \"moment\");\n\nasync = __webpack_require__(/*! async */ \"async\");\n\nmongoose = __webpack_require__(/*! mongoose */ \"mongoose\");\n\nValidate = __webpack_require__(/*! ../../validate */ \"./src/server/routers/validate.coffee\");\n\n//-------------------------------------------------------------------------------\n// Models\n//-------------------------------------------------------------------------------\nFeedback = mongoose.model('feedback');\n\n//-------------------------------------------------------------------------------\n// Sanitize given string\n//-------------------------------------------------------------------------------\nsanitize = function(string) {\n  return string.trim().toLowerCase().replace(' ', '');\n};\n\n//-------------------------------------------------------------------------------\n// Post\n//-------------------------------------------------------------------------------\nschema = {\n  title: [\n    {\n      method: 'isLength',\n      options: {\n        min: 1,\n        max: 25\n      }\n    }\n  ],\n  text: [\n    {\n      method: 'isLength',\n      options: {\n        min: 1,\n        max: 200\n      }\n    }\n  ]\n};\n\nexports.post = function(req, res) {\n  async.waterfall([\n    function(callback) {\n      return Validate.isValid(req.body,\n    schema,\n    callback);\n    },\n    function(callback) {\n      Feedback.create({\n        date: moment(),\n        title: sanitize(req.body.title),\n        text: sanitize(req.body.text),\n        type: 0\n      },\n    function(err,\n    feedback) {\n        if (err) {\n          return callback(err);\n        }\n        return callback(null,\n    feedback);\n      });\n    }\n  ], function(err, feedback) {\n    // Response error status and text.\n    if (err) {\n      return res.status(400).json(err);\n    } else {\n      return res.status(201).json(feedback);\n    }\n  });\n};\n\n//-------------------------------------------------------------------------------\n\n\n//# sourceURL=webpack:///./src/server/routers/index/feedback/module.coffee?");

/***/ }),

/***/ "./src/server/routers/index/forgot/module.coffee":
/*!*******************************************************!*\
  !*** ./src/server/routers/index/forgot/module.coffee ***!
  \*******************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

eval("//-------------------------------------------------------------------------------\n// Imports\n//-------------------------------------------------------------------------------\nvar Token, User, _, async, crypto, moment, mongoose, nodemailer, smtpTransport, transporter;\n\n_ = __webpack_require__(/*! lodash */ \"lodash\");\n\nmoment = __webpack_require__(/*! moment */ \"moment\");\n\nasync = __webpack_require__(/*! async */ \"async\");\n\nmongoose = __webpack_require__(/*! mongoose */ \"mongoose\");\n\ncrypto = __webpack_require__(/*! crypto */ \"crypto\");\n\n//-------------------------------------------------------------------------------\n// Imports\n//-------------------------------------------------------------------------------\nnodemailer = __webpack_require__(/*! nodemailer */ \"nodemailer\");\n\n//-------------------------------------------------------------------------------\n// Models\n//-------------------------------------------------------------------------------\nUser = mongoose.model('user');\n\nToken = mongoose.model('token');\n\n//-------------------------------------------------------------------------------\n\n// create reusable transporter object using the default SMTP transport\n//transporter = nodemailer.createTransport('smtps://vietxoulja12%40gmail.com:xoujas12@smtp.gmail.com')\nsmtpTransport = __webpack_require__(/*! nodemailer-smtp-transport */ \"nodemailer-smtp-transport\");\n\ntransporter = nodemailer.createTransport(smtpTransport({\n  service: 'gmail',\n  auth: {\n    user: 'vietxoulja12@gmail.com',\n    pass: ''\n  }\n}));\n\n//-------------------------------------------------------------------------------\n// Post\n//-------------------------------------------------------------------------------\nexports.post = function(req, res) {\n  var mailOptions;\n  mailOptions = {\n    from: '\"W.R Support Team\" <support@workoutrank.com>',\n    subject: 'Password Reset',\n    text: ''\n  };\n  async.waterfall([\n    function(callback) {\n      return User.findOne({\n        $or: [\n          {\n            username: req.body.user\n          },\n          {\n            email: req.body.user\n          }\n        ]\n      }).exec(function(err,\n    user) {\n        if (err) {\n          return callback(err);\n        }\n        if (user === null) {\n          return callback('Username / Email could not be found.');\n        }\n        return callback(null,\n    user);\n      });\n    },\n    function(user,\n    callback) {\n      var token;\n      token = crypto.randomBytes(16).toString('hex');\n      mailOptions.to = user.email;\n      mailOptions.html = `<a href='https://workoutrank.com/reset?user=${req.body.user}&token=${token}'>Click here to reset your password.<a>`;\n      return Token.create({\n        date: moment(),\n        token: token,\n        user: req.body.user\n      },\n    function(err,\n    token) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null);\n      });\n    },\n    function(callback) {\n      // send mail with defined transport object\n      transporter.sendMail(mailOptions,\n    function(error,\n    info) {\n        if (error) {\n          return error;\n        }\n      });\n      return callback(null);\n    }\n  ], function(err) {\n    // Response error status and text.\n    if (err) {\n      return res.status(400).json(err);\n    } else {\n      return res.status(201).json(req.body);\n    }\n  });\n};\n\n//-------------------------------------------------------------------------------\n\n\n//# sourceURL=webpack:///./src/server/routers/index/forgot/module.coffee?");

/***/ }),

/***/ "./src/server/routers/index/login/module.coffee":
/*!******************************************************!*\
  !*** ./src/server/routers/index/login/module.coffee ***!
  \******************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

eval("//-------------------------------------------------------------------------------\n// Imports\n//-------------------------------------------------------------------------------\nvar User, Validate, _, async, crypto, moment, mongoose, sanitize, schema;\n\n_ = __webpack_require__(/*! lodash */ \"lodash\");\n\nasync = __webpack_require__(/*! async */ \"async\");\n\nmoment = __webpack_require__(/*! moment */ \"moment\");\n\nmongoose = __webpack_require__(/*! mongoose */ \"mongoose\");\n\ncrypto = __webpack_require__(/*! crypto */ \"crypto\");\n\nValidate = __webpack_require__(/*! ../../validate */ \"./src/server/routers/validate.coffee\");\n\n//-------------------------------------------------------------------------------\n// Models\n//-------------------------------------------------------------------------------\nUser = mongoose.model('user');\n\n//-------------------------------------------------------------------------------\n// Sanitize given string\n//-------------------------------------------------------------------------------\nsanitize = function(string) {\n  return string.trim().toLowerCase().replace(' ', '');\n};\n\n//-------------------------------------------------------------------------------\n// Post\n//-------------------------------------------------------------------------------\nschema = {\n  user: [\n    {\n      method: 'isLength',\n      options: {\n        min: 2,\n        max: 25\n      }\n    }\n  ],\n  password: [\n    {\n      method: 'isLength',\n      options: {\n        min: 1,\n        max: 20\n      }\n    }\n  ]\n};\n\nexports.post = function(req, res) {\n  async.waterfall([\n    function(callback) {\n      return Validate.isValid(req.body,\n    schema,\n    callback);\n    },\n    function(callback) {\n      var user;\n      user = sanitize(req.body.user);\n      User.findOne({\n        $or: [\n          {\n            username: user\n          },\n          {\n            email: user\n          }\n        ]\n      }).exec(function(err,\n    user) {\n        if (err) {\n          return callback(err);\n        }\n        if (user === null) {\n          return callback('Username / Email could not be found.');\n        }\n        return callback(null,\n    user);\n      });\n    },\n    function(user,\n    callback) {\n      var algorithm,\n    password,\n    salt;\n      password = req.body.password;\n      salt = user.salt;\n      algorithm = user.algorithm;\n      crypto.pbkdf2(password,\n    salt,\n    user.rounds,\n    32,\n    algorithm,\n    function(err,\n    key) {\n        if (err) {\n          return callback('Could not look up username / password.');\n        }\n        if (user.key === key.toString('hex')) {\n          return callback(null,\n    user.getPublicFields());\n        } else {\n          return callback('Invalid username or password.');\n        }\n      });\n    },\n    function(user,\n    callback) {\n      if (user !== null) {\n        // If login was successful then\n        // Save user data to their session.\n        req.session.user = user;\n        // Update lastlogin time.\n        return User.findOneAndUpdate({\n          _id: user._id\n        },\n    {\n          lastlogin: moment()\n        },\n    function(err,\n    user) {\n          if (err) {\n            return callback(err.message);\n          }\n          return callback(null,\n    user);\n        });\n      } else {\n        req.session.user = null;\n        return callback(null);\n      }\n    }\n  ], function(err, user) {\n    // Response error status and text.\n    if (err) {\n      return res.status(400).json(err);\n    } else {\n      return res.status(201).json(user);\n    }\n  });\n};\n\n//-------------------------------------------------------------------------------\n\n\n//# sourceURL=webpack:///./src/server/routers/index/login/module.coffee?");

/***/ }),

/***/ "./src/server/routers/index/logout/module.coffee":
/*!*******************************************************!*\
  !*** ./src/server/routers/index/logout/module.coffee ***!
  \*******************************************************/
/*! no static exports found */
/***/ (function(module, exports) {

eval("//-------------------------------------------------------------------------------\n// Export\n//-------------------------------------------------------------------------------\nexports.post = function(req, res) {\n  req.logout();\n  // We cant redirect the user on server side. So send a 200 OK back to the client\n  // and have them do any redirection via javascript client side.\n  res.status(200).json({});\n};\n\n//-------------------------------------------------------------------------------\n\n\n//# sourceURL=webpack:///./src/server/routers/index/logout/module.coffee?");

/***/ }),

/***/ "./src/server/routers/index/module.coffee":
/*!************************************************!*\
  !*** ./src/server/routers/index/module.coffee ***!
  \************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

eval("//-------------------------------------------------------------------------------\n// Imports\n//-------------------------------------------------------------------------------\nvar express, feedback, forgot, i, index, len, login, logout, passport, ref, reset, router, signup, url;\n\nexpress = __webpack_require__(/*! express */ \"express\");\n\npassport = __webpack_require__(/*! passport */ \"passport\");\n\nrouter = express.Router();\n\n//-------------------------------------------------------------------------------\n// Import Routes\n//-------------------------------------------------------------------------------\nfeedback = __webpack_require__(/*! ./feedback/module */ \"./src/server/routers/index/feedback/module.coffee\");\n\nforgot = __webpack_require__(/*! ./forgot/module */ \"./src/server/routers/index/forgot/module.coffee\");\n\nsignup = __webpack_require__(/*! ./signup/module */ \"./src/server/routers/index/signup/module.coffee\");\n\nlogin = __webpack_require__(/*! ./login/module */ \"./src/server/routers/index/login/module.coffee\");\n\nlogout = __webpack_require__(/*! ./logout/module */ \"./src/server/routers/index/logout/module.coffee\");\n\nreset = __webpack_require__(/*! ./reset/module */ \"./src/server/routers/index/reset/module.coffee\");\n\n//-------------------------------------------------------------------------------\n// Path Routes.\n//   Pass index to all routes.\n//-------------------------------------------------------------------------------\nindex = function(req, res) {\n  res.render('index');\n};\n\nref = ['/', '/signup', '/login', '/about', '/feedback', '/forgot', '/reset'];\nfor (i = 0, len = ref.length; i < len; i++) {\n  url = ref[i];\n  router.use(url, express.static(__dirname + '/dist'));\n}\n\nrouter.get('/', index);\n\nrouter.get('/signup', index);\n\nrouter.get('/login', index);\n\nrouter.get('/about', index);\n\nrouter.get('/feedback', index);\n\nrouter.get('/forgot', index);\n\nrouter.get('/reset', index);\n\n//-------------------------------------------------------------------------------\n// API Routes for Resources.\n//-------------------------------------------------------------------------------\nrouter.post('/api/feedback', feedback.post);\n\nrouter.post('/api/forgot', forgot.post);\n\nrouter.post('/api/signup', signup.post);\n\nrouter.post('/api/logout', logout.post);\n\nrouter.post('/api/reset', reset.post);\n\n// If successful login.\nrouter.post('/api/login', passport.authenticate('local'), function(req, res) {\n  res.status(200);\n  res.json({});\n});\n\n//-------------------------------------------------------------------------------\n// Exports\n//-------------------------------------------------------------------------------\nmodule.exports = router;\n\n//-------------------------------------------------------------------------------\n\n\n//# sourceURL=webpack:///./src/server/routers/index/module.coffee?");

/***/ }),

/***/ "./src/server/routers/index/reset/module.coffee":
/*!******************************************************!*\
  !*** ./src/server/routers/index/reset/module.coffee ***!
  \******************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

eval("//-------------------------------------------------------------------------------\n// Imports\n//-------------------------------------------------------------------------------\nvar Token, User, _, async, crypto, moment, mongoose, sanitize;\n\n_ = __webpack_require__(/*! lodash */ \"lodash\");\n\nmoment = __webpack_require__(/*! moment */ \"moment\");\n\nasync = __webpack_require__(/*! async */ \"async\");\n\nmongoose = __webpack_require__(/*! mongoose */ \"mongoose\");\n\ncrypto = __webpack_require__(/*! crypto */ \"crypto\");\n\n//-------------------------------------------------------------------------------\n// Models\n//-------------------------------------------------------------------------------\nUser = mongoose.model('user');\n\nToken = mongoose.model('token');\n\n//-------------------------------------------------------------------------------\n// Sanitize given string\n//-------------------------------------------------------------------------------\nsanitize = function(string) {\n  return string.trim().toLowerCase().replace(' ', '');\n};\n\n//-------------------------------------------------------------------------------\n// Post\n//-------------------------------------------------------------------------------\nexports.post = function(req, res) {\n  async.waterfall([\n    function(callback) {\n      if (req.body.password !== req.body.confirm) {\n        return callback('Confirm passwords does not match.');\n      } else {\n        return callback(null);\n      }\n    },\n    function(callback) {\n      return Token.findOne({\n        user: req.body.user,\n        token: req.body.token\n      }).exec(function(err,\n    token) {\n        if (err) {\n          return callback(err);\n        }\n        if (token === null) {\n          return callback('Password reset session expired. Go back to step 1 and start over.');\n        } else {\n          return callback(null,\n    token);\n        }\n      });\n    },\n    function(token,\n    callback) {\n      var password,\n    salt;\n      password = req.body.password;\n      salt = crypto.randomBytes(32).toString('hex');\n      crypto.pbkdf2(password,\n    salt,\n    10000,\n    32,\n    'sha512',\n    function(err,\n    key) {\n        if (err) {\n          return callback('Could not process new password.');\n        }\n        return callback(null,\n    token,\n    salt,\n    key.toString('hex'));\n      });\n    },\n    function(token,\n    salt,\n    key,\n    callback) {\n      User.findOne({\n        $or: [\n          {\n            username: req.body.user\n          },\n          {\n            email: req.body.user\n          }\n        ]\n      }).exec(function(err,\n    user) {\n        if (err) {\n          return callback(err);\n        }\n        if (user === null) {\n          return callback('Username / Email could not be found.');\n        }\n        user.salt = salt;\n        user.key = key;\n        return callback(null,\n    token,\n    salt,\n    key,\n    user);\n      });\n    },\n    function(token,\n    salt,\n    key,\n    user,\n    callback) {\n      user.key = key;\n      user.salt = salt;\n      return user.save(function(err,\n    user) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    token);\n      });\n    },\n    function(token,\n    callback) {\n      token.remove(function(err) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null);\n      });\n    }\n  ], function(err) {\n    // Response error status and text.\n    if (err) {\n      return res.status(400).json(err);\n    } else {\n      return res.status(201).json(req.body);\n    }\n  });\n};\n\n//-------------------------------------------------------------------------------\n\n\n//# sourceURL=webpack:///./src/server/routers/index/reset/module.coffee?");

/***/ }),

/***/ "./src/server/routers/index/signup/data.coffee":
/*!*****************************************************!*\
  !*** ./src/server/routers/index/signup/data.coffee ***!
  \*****************************************************/
/*! no static exports found */
/***/ (function(module, exports) {

eval("exports.blacklist = ['about', 'account', 'add', 'admin', 'admins', 'api', 'app', 'apps', 'archive', 'archives', 'auth', 'better', 'billing', 'blog', 'cache', 'cdn', 'changelog', 'codereview', 'compare', 'config', 'connect', 'contact', 'create', 'delete', 'dev', 'direct_messages', 'downloads', 'edit', 'email', 'enterprise', 'faq', 'favorites', 'feed', 'feeds', 'follow', 'followers', 'following', 'ftp', 'gist', 'help', 'home', 'hosting', 'imap', 'invitations', 'invite', 'jobs', 'lists', 'log', 'login', 'logout', 'logs', 'mail', 'map', 'maps', 'master', 'messages', 'mine', 'news', 'next', 'oauth', 'oauth_clients', 'openid', 'organizations', 'plans', 'pop', 'popular', 'privacy', 'production', 'projects', 'register', 'remove', 'replies', 'rss', 'rsync', 'save', 'search', 'security', 'sessions', 'settings', 'sftp', 'shop', 'signup', 'sitemap', 'ssh', 'ssl', 'staging', 'status', 'stories', 'styleguide', 'subscribe', 'support', 'terms', 'test', 'tester', 'tour', 'translations', 'trends', 'unfollow', 'unsubscribe', 'url', 'user', 'widget', 'widgets', 'wiki', 'www', 'xfn', 'xmpp'];\n\n\n//# sourceURL=webpack:///./src/server/routers/index/signup/data.coffee?");

/***/ }),

/***/ "./src/server/routers/index/signup/module.coffee":
/*!*******************************************************!*\
  !*** ./src/server/routers/index/signup/module.coffee ***!
  \*******************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

eval("//-------------------------------------------------------------------------------\n// Imports\n//-------------------------------------------------------------------------------\nvar Data, RecaptchaSecret, User, Validate, _, async, crypto, moment, mongoose, request, requestIp, sanitize, schema;\n\n_ = __webpack_require__(/*! lodash */ \"lodash\");\n\nmoment = __webpack_require__(/*! moment */ \"moment\");\n\nasync = __webpack_require__(/*! async */ \"async\");\n\nrequest = __webpack_require__(/*! request */ \"request\");\n\nrequestIp = __webpack_require__(/*! request-ip */ \"request-ip\");\n\nmongoose = __webpack_require__(/*! mongoose */ \"mongoose\");\n\ncrypto = __webpack_require__(/*! crypto */ \"crypto\");\n\nValidate = __webpack_require__(/*! ../../validate */ \"./src/server/routers/validate.coffee\");\n\nData = __webpack_require__(/*! ./data */ \"./src/server/routers/index/signup/data.coffee\");\n\n//-------------------------------------------------------------------------------\n// Models\n//-------------------------------------------------------------------------------\nUser = mongoose.model('user');\n\n//-------------------------------------------------------------------------------\n// Data\n//   Recaptcha secret used to check if captcha response from client is correct.\n//-------------------------------------------------------------------------------\nRecaptchaSecret = '6LeGeBwTAAAAAJB1zR16oRVEPdZ-tYuOB2g9gY-0';\n\n//-------------------------------------------------------------------------------\n// Sanitize given string\n//-------------------------------------------------------------------------------\nsanitize = function(string) {\n  return string.trim().toLowerCase().replace(' ', '');\n};\n\n//-------------------------------------------------------------------------------\n// Post\n//-------------------------------------------------------------------------------\nschema = {\n  captcha: [],\n  email: [\n    {\n      method: 'isEmail'\n    },\n    {\n      method: 'isLength',\n      options: {\n        min: 4,\n        max: 35\n      }\n    }\n  ],\n  username: [\n    {\n      method: 'isLength',\n      options: {\n        min: 2,\n        max: 25\n      }\n    }\n  ],\n  password: [\n    {\n      method: 'isLength',\n      options: {\n        min: 4,\n        max: 20\n      }\n    }\n  ]\n};\n\nexports.post = function(req, res, next) {\n  var email, username;\n  email = sanitize(req.body.email);\n  username = sanitize(req.body.username);\n  async.waterfall([\n    function(callback) {\n      var i,\n    item,\n    len,\n    ref;\n      ref = Data.blacklist;\n      for (i = 0, len = ref.length; i < len; i++) {\n        item = ref[i];\n        if (username === item) {\n          return callback('Bad username. Choose a different username');\n        }\n      }\n      return callback(null);\n    },\n    function(callback) {\n      var clientIp;\n      clientIp = requestIp.getClientIp(req);\n      request.post({\n        url: 'https://www.google.com/recaptcha/api/siteverify',\n        formData: {\n          secret: RecaptchaSecret,\n          remoteIP: clientIp,\n          response: req.body.captcha\n        }\n      },\n    function(error,\n    response,\n    body) {\n        if (error) {\n          return callback(error);\n        }\n        body = JSON.parse(body);\n        if (body.success === false) {\n          return callback('Failed reCaptcha verification.');\n        }\n        return callback(null);\n      });\n    },\n    function(callback) {\n      return Validate.isValid(req.body,\n    schema,\n    callback);\n    },\n    function(callback) {\n      User.count({\n        email: email\n      },\n    function(err,\n    count) {\n        if (count > 0) {\n          return callback('Email has been taken. Choose a different email.');\n        } else {\n          return callback(null);\n        }\n      });\n    },\n    function(callback) {\n      User.count({\n        username: username\n      },\n    function(err,\n    count) {\n        if (count > 0) {\n          return callback('Username has been taken. Choose a different username.');\n        } else {\n          return callback(null);\n        }\n      });\n    },\n    function(callback) {\n      var salt;\n      salt = crypto.randomBytes(32);\n      return callback(null,\n    salt.toString('hex'));\n    },\n    function(salt,\n    callback) {\n      var password;\n      password = req.body.password;\n      salt = salt.toString('hex');\n      crypto.pbkdf2(password,\n    salt,\n    10000,\n    32,\n    'sha512',\n    function(err,\n    key) {\n        if (err) {\n          return callback('Could not process new password.');\n        }\n        return callback(null,\n    salt,\n    key.toString('hex'));\n      });\n    },\n    function(salt,\n    key,\n    callback) {\n      User.create({\n        auth: 1,\n        created: moment(),\n        lastlogin: moment(),\n        firstname: req.body.firstname,\n        lastname: req.body.lastname,\n        email: email,\n        username: username,\n        gender: req.body.gender,\n        salt: salt,\n        key: key,\n        algorithm: 'sha512',\n        rounds: 10000,\n        provider: 'local'\n      },\n    function(err,\n    user) {\n        if ((err != null ? err.code : void 0) === 11000) {\n          return callback('There was a problem. Cannot create new account.');\n        }\n        if (err) {\n          return callback(err);\n        }\n        return callback(null,\n    user.getPublicFields());\n      });\n    }\n  ], function(err, user) {\n    // If there was an error then response with error status and text.\n    if (err) {\n      return res.status(400).json(err);\n    } else {\n      req.login(user._id, function(err) {\n        if (err) {\n          return res.status(400).json(err);\n        } else {\n          // Send 201 status for successful record creation.\n          return res.status(201).json(user);\n        }\n      });\n    }\n  });\n};\n\n//-------------------------------------------------------------------------------\n\n\n//# sourceURL=webpack:///./src/server/routers/index/signup/module.coffee?");

/***/ }),

/***/ "./src/server/routers/main/cardio/module.coffee":
/*!******************************************************!*\
  !*** ./src/server/routers/main/cardio/module.coffee ***!
  \******************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

eval("/* WEBPACK VAR INJECTION */(function(module) {//-------------------------------------------------------------------------------\n// Imports\n//-------------------------------------------------------------------------------\nvar CLog, Cardio, async, moment, mongoose;\n\nmoment = __webpack_require__(/*! moment */ \"moment\");\n\nasync = __webpack_require__(/*! async */ \"async\");\n\nmongoose = __webpack_require__(/*! mongoose */ \"mongoose\");\n\n//-------------------------------------------------------------------------------\n// Models\n//-------------------------------------------------------------------------------\nCardio = mongoose.model('cardio');\n\nCLog = mongoose.model('clog');\n\n//-------------------------------------------------------------------------------\n// List\n//   Return all cardio exercises matching user id.\n//-------------------------------------------------------------------------------\nmodule.list = function(req, res) {\n  return async.waterfall([\n    function(callback) {\n      Cardio.find({\n        user: req.session.passport.user\n      }).sort({\n        date: -1\n      }).lean().exec(function(err,\n    cardios) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    cardios);\n      });\n    }\n  ], function(err, cardios) {\n    // Response error status and text.\n    if (err) {\n      res.status(400).json(err);\n    }\n    return res.json(cardios);\n  });\n};\n\n//-------------------------------------------------------------------------------\n// Get\n//   Get a specific cardio workout matching cardio ID.\n//-------------------------------------------------------------------------------\nmodule.get = function(req, res) {\n  return async.waterfall([\n    function(callback) {\n      Cardio.findOne({\n        _id: req.params.cid\n      }).exec(function(err,\n    cardio) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    cardio);\n      });\n    }\n  ], function(err, cardio) {\n    // Response error status and text.\n    if (err) {\n      res.status(400).json(err);\n    }\n    return res.json(cardio);\n  });\n};\n\n//-------------------------------------------------------------------------------\n// Post\n//   Create a new cardio exercise.\n//-------------------------------------------------------------------------------\nmodule.post = function(req, res) {\n  async.waterfall([\n    function(callback) {\n      return Cardio.create({\n        date: moment(),\n        name: req.body.name,\n        note: req.body.note,\n        user: req.session.passport.user\n      },\n    function(err,\n    cardio) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    cardio);\n      });\n    }\n  ], function(err, cardio) {\n    // If Error occured, return error status and text.\n    if (err) {\n      res.status(400).json(err);\n    }\n    // If success return a 201 status code and json.\n    res.status(201).json(cardio);\n  });\n};\n\n//-------------------------------------------------------------------------------\n// PUT\n//   Edit a new cardio exercise.\n//-------------------------------------------------------------------------------\nmodule.put = function(req, res) {\n  return async.waterfall([\n    function(callback) {\n      Cardio.findById(req.params.cid,\n    function(err,\n    cardio) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    cardio);\n      });\n    },\n    function(cardio,\n    callback) {\n      cardio.date = req.body.date;\n      cardio.name = req.body.name;\n      cardio.note = req.body.note;\n      cardio.save(function(err,\n    entry) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    entry);\n      });\n    }\n  ], function(err, entry) {\n    if (err) {\n      res.status(400).json(err);\n    }\n    // Return json if success.\n    return res.json(entry);\n  });\n};\n\n//-------------------------------------------------------------------------------\n// Delete\n//   Delete a sConf record.\n//-------------------------------------------------------------------------------\nmodule.delete = function(req, res) {\n  return async.waterfall([\n    function(callback) {\n      Cardio.findById(req.params.cid,\n    function(err,\n    cardio) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    cardio);\n      });\n    },\n    function(cardio,\n    callback) {\n      // Remove all associated clogs.\n      CLog.remove({\n        exerciseID: cardio.id\n      }).exec(function(err) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    cardio);\n      });\n    },\n    function(cardio,\n    callback) {\n      // Remove the actual sconf entry.\n      cardio.remove(function(err) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null);\n      });\n    }\n  ], function(err) {\n    if (err) {\n      res.status(400).json(err);\n    }\n    res.sendStatus(204);\n  });\n};\n\n//-------------------------------------------------------------------------------\n// Exports\n//-------------------------------------------------------------------------------\nmodule.exports = module;\n\n//-------------------------------------------------------------------------------\n\n/* WEBPACK VAR INJECTION */}.call(this, __webpack_require__(/*! ./../../../../../node_modules/webpack/buildin/module.js */ \"./node_modules/webpack/buildin/module.js\")(module)))\n\n//# sourceURL=webpack:///./src/server/routers/main/cardio/module.coffee?");

/***/ }),

/***/ "./src/server/routers/main/clog/module.coffee":
/*!****************************************************!*\
  !*** ./src/server/routers/main/clog/module.coffee ***!
  \****************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

eval("/* WEBPACK VAR INJECTION */(function(module) {//-------------------------------------------------------------------------------\n// Imports\n//-------------------------------------------------------------------------------\nvar CLog, async, moment, mongoose;\n\nmoment = __webpack_require__(/*! moment */ \"moment\");\n\nasync = __webpack_require__(/*! async */ \"async\");\n\nmongoose = __webpack_require__(/*! mongoose */ \"mongoose\");\n\n//-------------------------------------------------------------------------------\n// Models\n//-------------------------------------------------------------------------------\nCLog = mongoose.model('clog');\n\n//-------------------------------------------------------------------------------\n// List\n//   Get all clogs from this user.\n//-------------------------------------------------------------------------------\nmodule.list = function(req, res) {\n  return async.waterfall([\n    function(callback) {\n      CLog.find({\n        user: req.session.passport.user\n      }).lean().exec(function(err,\n    clogs) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    clogs);\n      });\n    }\n  ], function(err, documents) {\n    if (err) {\n      res.status(400).json(err);\n    }\n    return res.json(documents);\n  });\n};\n\n//-------------------------------------------------------------------------------\n// Get\n//   Get a specific clogs with matching strengthID\n//-------------------------------------------------------------------------------\nmodule.get = function(req, res) {\n  return async.waterfall([\n    function(callback) {\n      CLog.find({\n        exerciseID: req.params.cid\n      }).lean().exec(function(err,\n    clogs) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    clogs);\n      });\n    }\n  ], function(err, documents) {\n    if (err) {\n      res.status(400).json(err);\n    }\n    return res.json(documents);\n  });\n};\n\n//-------------------------------------------------------------------------------\n// Post\n//   Create a new clog. As well as updating the strength workout's last date.\n//-------------------------------------------------------------------------------\nmodule.post = function(req, res) {\n  async.waterfall([\n    function(callback) {\n      \n      // Create a new clog entry.\n      return CLog.create({\n        created: req.body.date,\n        note: req.body.note,\n        intensity: req.body.intensity,\n        speed: req.body.speed,\n        duration: req.body.duration,\n        user: req.session.passport.user,\n        exerciseID: req.body.exerciseID\n      },\n    function(err,\n    clog) {\n        if (err) {\n          return callback(err.errors);\n        }\n        return callback(null,\n    clog);\n      });\n    }\n  ], function(err, clog) {\n    if (err) {\n      res.status(400).json(err);\n    }\n    res.status(201).json(clog);\n  });\n};\n\n//-------------------------------------------------------------------------------\n// Put\n//   Edit a clog record.\n//-------------------------------------------------------------------------------\nmodule.put = function(req, res) {\n  return async.waterfall([\n    function(callback) {\n      CLog.findById(req.params.Cid,\n    function(err,\n    clog) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    clog);\n      });\n    },\n    function(clog,\n    callback) {\n      clog.created = moment();\n      clog.note = req.body.note;\n      clog.intensity = req.body.intensity;\n      clog.speed = req.body.speed;\n      clog.duration = req.body.duration;\n      clog.exerciseID = req.body.exerciseID;\n      clog.save(function(err,\n    clog) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    clog);\n      });\n    }\n  ], function(err, document) {\n    if (err) {\n      res.status(400).json(err);\n    }\n    // Return json if success.\n    return res.json(document);\n  });\n};\n\n//-------------------------------------------------------------------------------\n// Delete\n//   Delete a clog record.\n//-------------------------------------------------------------------------------\nmodule.delete = function(req, res) {\n  return async.waterfall([\n    function(callback) {\n      CLog.findById(req.params.cid,\n    function(err,\n    clog) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    clog);\n      });\n    },\n    function(clog,\n    callback) {\n      clog.remove(function(err) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null);\n      });\n    }\n  ], function(err) {\n    if (err) {\n      res.status(202).json(err);\n    }\n    res.sendStatus(204);\n  });\n};\n\n//-------------------------------------------------------------------------------\n// Exports\n//-------------------------------------------------------------------------------\nmodule.exports = module;\n\n//-------------------------------------------------------------------------------\n\n/* WEBPACK VAR INJECTION */}.call(this, __webpack_require__(/*! ./../../../../../node_modules/webpack/buildin/module.js */ \"./node_modules/webpack/buildin/module.js\")(module)))\n\n//# sourceURL=webpack:///./src/server/routers/main/clog/module.coffee?");

/***/ }),

/***/ "./src/server/routers/main/home/module.coffee":
/*!****************************************************!*\
  !*** ./src/server/routers/main/home/module.coffee ***!
  \****************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

eval("/* WEBPACK VAR INJECTION */(function(module) {//-------------------------------------------------------------------------------\n// Imports\n//-------------------------------------------------------------------------------\nvar CLog, Cardio, Feedback, Image, SLog, Schedule, Strength, User, WLog, async, mongoose;\n\nasync = __webpack_require__(/*! async */ \"async\");\n\nmongoose = __webpack_require__(/*! mongoose */ \"mongoose\");\n\n//-------------------------------------------------------------------------------\n// Models\n//-------------------------------------------------------------------------------\nStrength = mongoose.model('strength');\n\nSLog = mongoose.model('slog');\n\nCardio = mongoose.model('cardio');\n\nCLog = mongoose.model('clog');\n\nWLog = mongoose.model('wlog');\n\nSchedule = mongoose.model('schedule');\n\nFeedback = mongoose.model('feedback');\n\nUser = mongoose.model('user');\n\nImage = mongoose.model('image');\n\n//-------------------------------------------------------------------------------\n// GET\n\n//   Get count of all exercises and all logs.\n//-------------------------------------------------------------------------------\nmodule.get = function(req, res) {\n  var result;\n  result = {\n    sConfs: 0,\n    sLogs: 0,\n    cConfs: 0,\n    cLogs: 0,\n    wLogs: 0,\n    users: 0,\n    feedbacks: 0,\n    profilePic: 0,\n    imageCount: 0,\n    scheduleCount: 0\n  };\n  return async.waterfall([\n    function(callback) {\n      Strength.count({\n        user: req.session.passport.user\n      }).lean().exec(function(err,\n    count) {\n        if (err) {\n          return callback(err.message);\n        }\n        result.sConfs = count;\n        return callback(null);\n      });\n    },\n    function(callback) {\n      SLog.count({\n        user: req.session.passport.user\n      }).lean().exec(function(err,\n    count) {\n        if (err) {\n          return callback(err.message);\n        }\n        result.sLogs = count;\n        return callback(null);\n      });\n    },\n    function(callback) {\n      Cardio.count({\n        user: req.session.passport.user\n      }).lean().exec(function(err,\n    count) {\n        if (err) {\n          return callback(err.message);\n        }\n        result.cConfs = count;\n        return callback(null);\n      });\n    },\n    function(callback) {\n      CLog.count({\n        user: req.session.passport.user\n      }).lean().exec(function(err,\n    count) {\n        if (err) {\n          return callback(err.message);\n        }\n        result.cLogs = count;\n        return callback(null);\n      });\n    },\n    function(callback) {\n      WLog.count({\n        user: req.session.passport.user\n      }).lean().exec(function(err,\n    count) {\n        if (err) {\n          return callback(err.message);\n        }\n        result.wLogs = count;\n        return callback(null);\n      });\n    },\n    function(callback) {\n      Feedback.count().lean().exec(function(err,\n    count) {\n        if (err) {\n          return callback(err.message);\n        }\n        result.feedbacks = count;\n        return callback(null);\n      });\n    },\n    function(callback) {\n      User.count().lean().exec(function(err,\n    count) {\n        if (err) {\n          return callback(err.message);\n        }\n        result.users = count;\n        return callback(null);\n      });\n    },\n    function(callback) {\n      Image.count().lean().exec(function(err,\n    count) {\n        if (err) {\n          return callback(err.message);\n        }\n        result.imageCount = count;\n        return callback(null);\n      });\n    },\n    function(callback) {\n      Schedule.count().lean().exec(function(err,\n    count) {\n        if (err) {\n          return callback(err.message);\n        }\n        result.scheduleCount = count;\n        return callback(null);\n      });\n    },\n    function(callback) {\n      Image.findOne({\n        user: req.session.passport.user,\n        imageType: 'profile'\n      }).lean().exec(function(err,\n    image) {\n        if (err) {\n          return callback(err.message);\n        }\n        result.profilePic = image;\n        return callback(null);\n      });\n    },\n    function(callback) {\n      Schedule.findOne({\n        user: req.session.passport.user\n      }).lean().exec(function(err,\n    schedule) {\n        if (err) {\n          return callback(err.message);\n        }\n        if (schedule != null) {\n          result.schedules += schedule.sunday.length;\n          result.schedules += schedule.monday.length;\n          result.schedules += schedule.tuesday.length;\n          result.schedules += schedule.wednesday.length;\n          result.schedules += schedule.thursday.length;\n          result.schedules += schedule.friday.length;\n          result.schedules += schedule.saturday.length;\n        }\n        return callback(null);\n      });\n    }\n  ], function(err) {\n    // If Error occurred, return error status and text.\n    if (err) {\n      res.status(400).json(err);\n    } else {\n      res.status(200).json(result);\n    }\n  });\n};\n\n//-------------------------------------------------------------------------------\n// Exports\n//-------------------------------------------------------------------------------\nmodule.exports = module;\n\n//-------------------------------------------------------------------------------\n\n/* WEBPACK VAR INJECTION */}.call(this, __webpack_require__(/*! ./../../../../../node_modules/webpack/buildin/module.js */ \"./node_modules/webpack/buildin/module.js\")(module)))\n\n//# sourceURL=webpack:///./src/server/routers/main/home/module.coffee?");

/***/ }),

/***/ "./src/server/routers/main/image/module.coffee":
/*!*****************************************************!*\
  !*** ./src/server/routers/main/image/module.coffee ***!
  \*****************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

eval("/* WEBPACK VAR INJECTION */(function(module) {//-------------------------------------------------------------------------------\n// Imports\n//-------------------------------------------------------------------------------\nvar Image, async, mongoose;\n\nasync = __webpack_require__(/*! async */ \"async\");\n\nmongoose = __webpack_require__(/*! mongoose */ \"mongoose\");\n\n//-------------------------------------------------------------------------------\n// Models\n//-------------------------------------------------------------------------------\nImage = mongoose.model('image');\n\n//-------------------------------------------------------------------------------\n// List\n//   Get all images from this user.\n//-------------------------------------------------------------------------------\nmodule.list = function(req, res) {\n  return async.waterfall([\n    function(callback) {\n      Image.find({\n        user: req.session.passport.user\n      }).lean().exec(function(err,\n    images) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    images);\n      });\n    }\n  ], function(err, documents) {\n    if (err) {\n      res.status(400).json(err);\n    }\n    return res.json(documents);\n  });\n};\n\n//-------------------------------------------------------------------------------\n// Get\n//   Get a specific images with matching strengthID\n//-------------------------------------------------------------------------------\nmodule.get = function(req, res) {\n  return async.waterfall([\n    function(callback) {\n      WLog.find({\n        exercise: req.params.sid\n      }).lean().exec(function(err,\n    images) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    images);\n      });\n    }\n  ], function(err, documents) {\n    if (err) {\n      res.status(400).json(err);\n    }\n    return res.json(documents);\n  });\n};\n\n//-------------------------------------------------------------------------------\n// Post\n//   Create a new image. As well as updating the strength workout's last date.\n//-------------------------------------------------------------------------------\nmodule.post = function(req, res) {\n  async.waterfall([\n    function(callback) {\n      // Create a new image entry.\n      return WLog.create({\n        date: req.body.date,\n        note: req.body.note,\n        weight: req.body.weight,\n        user: req.session.passport.user\n      },\n    function(err,\n    image) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    image);\n      });\n    }\n  ], function(err, image) {\n    if (err) {\n      res.status(400).json(err);\n    }\n    res.status(201).json(image);\n  });\n};\n\n//-------------------------------------------------------------------------------\n// Put\n//   Edit a image record.\n//-------------------------------------------------------------------------------\nmodule.put = function(req, res) {\n  return async.waterfall([\n    function(callback) {\n      WLog.findById(req.params.sid,\n    function(err,\n    image) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    image);\n      });\n    },\n    function(image,\n    callback) {\n      image.date = req.body.date;\n      image.muscle = req.body.muscle;\n      image.note = req.body.note;\n      image.session = req.body.session;\n      image.save(function(err,\n    image) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    image);\n      });\n    }\n  ], function(err, document) {\n    if (err) {\n      res.status(400).json(err);\n    }\n    // Return json if success.\n    return res.json(document);\n  });\n};\n\n//-------------------------------------------------------------------------------\n// Delete\n//   Delete a image record.\n//-------------------------------------------------------------------------------\nmodule.delete = function(req, res) {\n  return async.waterfall([\n    function(callback) {\n      WLog.findById(req.params.sid,\n    function(err,\n    image) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    image);\n      });\n    },\n    function(image,\n    callback) {\n      image.remove(function(err) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null);\n      });\n    }\n  ], function(err) {\n    if (err) {\n      res.status(202).json(err);\n    }\n    res.sendStatus(204);\n  });\n};\n\n//-------------------------------------------------------------------------------\n// Exports\n//-------------------------------------------------------------------------------\nmodule.exports = module;\n\n//-------------------------------------------------------------------------------\n\n/* WEBPACK VAR INJECTION */}.call(this, __webpack_require__(/*! ./../../../../../node_modules/webpack/buildin/module.js */ \"./node_modules/webpack/buildin/module.js\")(module)))\n\n//# sourceURL=webpack:///./src/server/routers/main/image/module.coffee?");

/***/ }),

/***/ "./src/server/routers/main/module.coffee":
/*!***********************************************!*\
  !*** ./src/server/routers/main/module.coffee ***!
  \***********************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

eval("//-------------------------------------------------------------------------------\n// Imports\n//-------------------------------------------------------------------------------\nvar CLog, Cardio, Home, Image, SLog, Schedule, Strength, WLog, _, express, i, len, middleware, middlewares, router, url, urls;\n\n_ = __webpack_require__(/*! lodash */ \"lodash\");\n\nexpress = __webpack_require__(/*! express */ \"express\");\n\nmiddleware = __webpack_require__(/*! ../../middleware */ \"./src/server/middleware.coffee\");\n\nrouter = express.Router();\n\n//-------------------------------------------------------------------------------\n// Route Middleware\n//-------------------------------------------------------------------------------\nmiddlewares = [middleware.isAuthenticated];\n\n//-------------------------------------------------------------------------------\n// Path Routes.\n//   Pass index to all routes.\n//-------------------------------------------------------------------------------\nurls = ['/home', '/exercise', '/calendar', '/schedule', '/strengths', '/cardios', '/weights', '/body', '/timeline'];\n\nfor (i = 0, len = urls.length; i < len; i++) {\n  url = urls[i];\n  router.use(url, express.static(__dirname + '/dist'));\n  router.get(url, middlewares, function(req, res) {\n    res.render('index');\n  });\n}\n\n//-------------------------------------------------------------------------------\n// Import Routes\n//-------------------------------------------------------------------------------\nHome = __webpack_require__(/*! ./home/module */ \"./src/server/routers/main/home/module.coffee\");\n\nStrength = __webpack_require__(/*! ./strength/module */ \"./src/server/routers/main/strength/module.coffee\");\n\nCardio = __webpack_require__(/*! ./cardio/module */ \"./src/server/routers/main/cardio/module.coffee\");\n\nCLog = __webpack_require__(/*! ./clog/module */ \"./src/server/routers/main/clog/module.coffee\");\n\nSLog = __webpack_require__(/*! ./slog/module */ \"./src/server/routers/main/slog/module.coffee\");\n\nWLog = __webpack_require__(/*! ./wlog/module */ \"./src/server/routers/main/wlog/module.coffee\");\n\nImage = __webpack_require__(/*! ./image/module */ \"./src/server/routers/main/image/module.coffee\");\n\nSchedule = __webpack_require__(/*! ./schedule/module */ \"./src/server/routers/main/schedule/module.coffee\");\n\n//-------------------------------------------------------------------------------\n// XHR Middleware\n//-------------------------------------------------------------------------------\nmiddlewares = [middleware.isAuthenticated];\n\n//-------------------------------------------------------------------------------\n// API Routes for Resources.\n//-------------------------------------------------------------------------------\nrouter.get('/api/home', middlewares, Home.get);\n\n//-------------------------------------------------------------------------------\n// Strengths\n//-------------------------------------------------------------------------------\n\n// Get all strength exercises belonging to a user.\nrouter.get('/api/strengths', middlewares, Strength.list);\n\n// Get a specific strength workout matching strength ID.\nrouter.get('/api/strengths/:sid', middlewares, Strength.get);\n\nrouter.put('/api/strengths/:sid', middlewares, Strength.put);\n\n// Post a new strength exercise for an user.\nrouter.post('/api/strengths', middlewares, Strength.post);\n\n// Get all slog for a strength exercise.\nrouter.get('/api/strengths/:sid/log', middlewares, Strength.log);\n\n// Delete a strength exercise.\nrouter.delete('/api/strengths/:sid', middlewares, Strength.delete);\n\n//-------------------------------------------------------------------------------\n// Strength Logs\n//-------------------------------------------------------------------------------\nrouter.get('/api/slogs', middlewares, SLog.list);\n\nrouter.post('/api/slogs', middlewares, SLog.post);\n\nrouter.get('/api/slogs/:sid', middlewares, SLog.get);\n\nrouter.put('/api/slogs/:sid', middlewares, SLog.put);\n\nrouter.delete('/api/slogs/:sid', middlewares, SLog.delete);\n\n//-------------------------------------------------------------------------------\n// Cardio Conf\n//-------------------------------------------------------------------------------\nrouter.get('/api/cardios', middlewares, Cardio.list);\n\nrouter.get('/api/cardios/:cid', middlewares, Cardio.get);\n\nrouter.put('/api/cardios/:cid', middlewares, Cardio.put);\n\nrouter.post('/api/cardios', middlewares, Cardio.post);\n\nrouter.delete('/api/cardios/:cid', middlewares, Cardio.delete);\n\n//-------------------------------------------------------------------------------\n// Cardio Logs\n//-------------------------------------------------------------------------------\nrouter.get('/api/clogs', middlewares, CLog.list);\n\nrouter.post('/api/clogs', middlewares, CLog.post);\n\nrouter.get('/api/clogs/:cid', middlewares, CLog.get);\n\nrouter.put('/api/clogs/:cid', middlewares, CLog.put);\n\nrouter.delete('/api/clogs/:cid', middlewares, CLog.delete);\n\n//-------------------------------------------------------------------------------\n// Image\n//-------------------------------------------------------------------------------\nrouter.get('/api/images', middlewares, Image.list);\n\nrouter.post('/api/images', middlewares, Image.post);\n\nrouter.get('/api/images/:cid', middlewares, Image.get);\n\nrouter.put('/api/images/:cid', middlewares, Image.put);\n\nrouter.delete('/api/images/:cid', middlewares, Image.delete);\n\n//-------------------------------------------------------------------------------\n// Schedule\n//-------------------------------------------------------------------------------\n\n// Post a new schedule record.\nrouter.get('/api/schedule', middlewares, Schedule.get);\n\n// Post a new schedule record.\nrouter.post('/api/schedule', middlewares, Schedule.post);\n\n// Edit schedules.\nrouter.put('/api/schedule/:sid', middlewares, Schedule.put);\n\n//-------------------------------------------------------------------------------\n// Weight Logs\n//-------------------------------------------------------------------------------\n\n// Get all slogs.\nrouter.get('/api/wlogs', middlewares, WLog.list);\n\n// Post a new wlog record.\nrouter.post('/api/wlogs', middlewares, WLog.post);\n\n// Get a specific wlog.\nrouter.get('/api/wlogs/:sid', middlewares, WLog.get);\n\n// Edit a specific wlog record.\nrouter.put('/api/wlogs/:sid', middlewares, WLog.put);\n\n// Delete a specific wlog record.\nrouter.delete('/api/wlogs/:sid', middlewares, WLog.delete);\n\n//-------------------------------------------------------------------------------\n// Exports\n//-------------------------------------------------------------------------------\nmodule.exports = router;\n\n//-------------------------------------------------------------------------------\n\n\n//# sourceURL=webpack:///./src/server/routers/main/module.coffee?");

/***/ }),

/***/ "./src/server/routers/main/schedule/module.coffee":
/*!********************************************************!*\
  !*** ./src/server/routers/main/schedule/module.coffee ***!
  \********************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

eval("/* WEBPACK VAR INJECTION */(function(module) {//-------------------------------------------------------------------------------\n// Imports\n//-------------------------------------------------------------------------------\nvar Err, Schedule, Validate, _, async, moment, mongoose, schema;\n\n_ = __webpack_require__(/*! lodash */ \"lodash\");\n\nmoment = __webpack_require__(/*! moment */ \"moment\");\n\nasync = __webpack_require__(/*! async */ \"async\");\n\nmongoose = __webpack_require__(/*! mongoose */ \"mongoose\");\n\nErr = __webpack_require__(/*! ../../error */ \"./src/server/routers/error.coffee\");\n\nValidate = __webpack_require__(/*! ../../validate */ \"./src/server/routers/validate.coffee\");\n\n//-------------------------------------------------------------------------------\n// Models\n//-------------------------------------------------------------------------------\nSchedule = mongoose.model('schedule');\n\n//-------------------------------------------------------------------------------\n// Schema for POST and PUT validation\n//-------------------------------------------------------------------------------\nschema = {\n  sunday: [],\n  monday: [],\n  tuesday: [],\n  wednesday: [],\n  thursday: [],\n  friday: [],\n  saturday: []\n};\n\n//-------------------------------------------------------------------------------\n// Get\n//-------------------------------------------------------------------------------\nmodule.get = function(req, res) {\n  return async.waterfall([\n    function(callback) {\n      Schedule.findOne({\n        user: req.session.passport.user\n      }).lean().exec(function(err,\n    schedule) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    schedule);\n      });\n    }\n  ], function(err, schedule) {\n    // Response error status and text.\n    if (err) {\n      res.status(400).json(err);\n    }\n    return res.json(schedule);\n  });\n};\n\n//-------------------------------------------------------------------------------\n// Post\n//   Create a new strength exercise.\n//-------------------------------------------------------------------------------\nmodule.post = function(req, res) {\n  async.waterfall([\n    function(callback) {\n      return Validate.isValid(req.body,\n    schema,\n    callback);\n    },\n    function(callback) {\n      return Schedule.create({\n        user: req.session.passport.user,\n        date: moment(),\n        sunday: req.body.sunday,\n        monday: req.body.monday,\n        tuesday: req.body.tuesday,\n        wednesday: req.body.wednesday,\n        thursday: req.body.thursday,\n        friday: req.body.friday,\n        saturday: req.body.saturday\n      },\n    function(err,\n    schedule) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    schedule);\n      });\n    }\n  ], function(err, strength) {\n    // If Error occured, return error status and text.\n    if (err) {\n      res.status(400).json(err);\n    }\n    // If success return a 201 status code and json.\n    res.status(201).json(strength);\n  });\n};\n\n//-------------------------------------------------------------------------------\n// PUT\n//   Edit a new strength exercise.\n//-------------------------------------------------------------------------------\nmodule.put = function(req, res) {\n  return async.waterfall([\n    function(callback) {\n      return Validate.isValid(req.body,\n    schema,\n    callback);\n    },\n    function(callback) {\n      Schedule.findById(req.params.sid,\n    function(err,\n    schedule) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    schedule);\n      });\n    },\n    function(schedule,\n    callback) {\n      schedule.date = moment();\n      schedule.sunday = req.body.sunday;\n      schedule.monday = req.body.monday;\n      schedule.tuesday = req.body.tuesday;\n      schedule.wednesday = req.body.wednesday;\n      schedule.thursday = req.body.thursday;\n      schedule.friday = req.body.friday;\n      schedule.saturday = req.body.saturday;\n      schedule.save(function(err,\n    entry) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    entry);\n      });\n    }\n  ], function(err, entry) {\n    if (err) {\n      res.status(400).json(err);\n    }\n    // Return json if success.\n    return res.json(entry);\n  });\n};\n\n//-------------------------------------------------------------------------------\n// Exports\n//-------------------------------------------------------------------------------\nmodule.exports = module;\n\n//-------------------------------------------------------------------------------\n\n/* WEBPACK VAR INJECTION */}.call(this, __webpack_require__(/*! ./../../../../../node_modules/webpack/buildin/module.js */ \"./node_modules/webpack/buildin/module.js\")(module)))\n\n//# sourceURL=webpack:///./src/server/routers/main/schedule/module.coffee?");

/***/ }),

/***/ "./src/server/routers/main/slog/module.coffee":
/*!****************************************************!*\
  !*** ./src/server/routers/main/slog/module.coffee ***!
  \****************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

eval("/* WEBPACK VAR INJECTION */(function(module) {//-------------------------------------------------------------------------------\n// Imports\n//-------------------------------------------------------------------------------\nvar SLog, Strength, _, async, mongoose;\n\n_ = __webpack_require__(/*! lodash */ \"lodash\");\n\nasync = __webpack_require__(/*! async */ \"async\");\n\nmongoose = __webpack_require__(/*! mongoose */ \"mongoose\");\n\n//-------------------------------------------------------------------------------\n// Models\n//-------------------------------------------------------------------------------\nSLog = mongoose.model('slog');\n\nStrength = mongoose.model('strength');\n\n//-------------------------------------------------------------------------------\n// List\n//   Get all slogs from this user.\n//-------------------------------------------------------------------------------\nmodule.list = function(req, res) {\n  return async.waterfall([\n    function(callback) {\n      SLog.find({\n        user: req.session.passport.user\n      }).lean().exec(function(err,\n    slogs) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    slogs);\n      });\n    }\n  ], function(err, documents) {\n    if (err) {\n      res.status(400).json(err);\n    }\n    return res.json(documents);\n  });\n};\n\n//-------------------------------------------------------------------------------\n// Get\n//   Get a specific slogs with matching strengthID\n//-------------------------------------------------------------------------------\nmodule.get = function(req, res) {\n  return async.waterfall([\n    function(callback) {\n      SLog.find({\n        exercise: req.params.sid\n      }).lean().exec(function(err,\n    slogs) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    slogs);\n      });\n    }\n  ], function(err, documents) {\n    if (err) {\n      res.status(400).json(err);\n    }\n    return res.json(documents);\n  });\n};\n\n//-------------------------------------------------------------------------------\n// Post\n//   Create a new slog. As well as updating the strength workout's last date.\n//-------------------------------------------------------------------------------\nmodule.post = function(req, res) {\n  async.waterfall([\n    function(callback) {\n      var err;\n      err = null;\n      if (req.body.weight === null) {\n        err = 'Weight cannot be empty';\n      }\n      if (req.body.rep === null) {\n        err = 'Reps cannot be empty';\n      }\n      return callback(err);\n    },\n    function(callback) {\n      // Find the specific strength exercise.\n      Strength.findById(req.body.exercise,\n    function(err,\n    strength) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    strength);\n      });\n    },\n    function(strength,\n    callback) {\n      // Update that strength's last date.\n      strength.date = req.body.date;\n      strength.save(function(err) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null);\n      });\n    },\n    function(callback) {\n      // Create a new slog entry.\n      return SLog.create({\n        date: req.body.date,\n        exercise: req.body.exercise,\n        note: req.body.note,\n        rep: req.body.rep,\n        weight: req.body.weight,\n        user: req.session.passport.user\n      },\n    function(err,\n    slog) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    slog);\n      });\n    }\n  ], function(err, slog) {\n    if (err) {\n      res.status(400).json(err);\n    }\n    res.status(201).json(slog);\n  });\n};\n\n//-------------------------------------------------------------------------------\n// Put\n//   Edit a slog record.\n//-------------------------------------------------------------------------------\nmodule.put = function(req, res) {\n  return async.waterfall([\n    function(callback) {\n      SLog.findById(req.params.sid,\n    function(err,\n    slog) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    slog);\n      });\n    },\n    function(slog,\n    callback) {\n      slog.date = req.body.date;\n      slog.muscle = req.body.muscle;\n      slog.note = req.body.note;\n      slog.session = req.body.session;\n      slog.save(function(err,\n    slog) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    slog);\n      });\n    }\n  ], function(err, document) {\n    if (err) {\n      res.status(400).json(err);\n    }\n    // Return json if success.\n    return res.json(document);\n  });\n};\n\n//-------------------------------------------------------------------------------\n// Delete\n//   Delete a slog record.\n//-------------------------------------------------------------------------------\nmodule.delete = function(req, res) {\n  return async.waterfall([\n    function(callback) {\n      SLog.findById(req.params.sid,\n    function(err,\n    slog) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    slog);\n      });\n    },\n    function(slog,\n    callback) {\n      slog.remove(function(err) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null);\n      });\n    }\n  ], function(err) {\n    if (err) {\n      res.status(202).json(err);\n    }\n    res.sendStatus(204);\n  });\n};\n\n//-------------------------------------------------------------------------------\n// Exports\n//-------------------------------------------------------------------------------\nmodule.exports = module;\n\n//-------------------------------------------------------------------------------\n\n/* WEBPACK VAR INJECTION */}.call(this, __webpack_require__(/*! ./../../../../../node_modules/webpack/buildin/module.js */ \"./node_modules/webpack/buildin/module.js\")(module)))\n\n//# sourceURL=webpack:///./src/server/routers/main/slog/module.coffee?");

/***/ }),

/***/ "./src/server/routers/main/strength/module.coffee":
/*!********************************************************!*\
  !*** ./src/server/routers/main/strength/module.coffee ***!
  \********************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

eval("/* WEBPACK VAR INJECTION */(function(module) {//-------------------------------------------------------------------------------\n// Imports\n//-------------------------------------------------------------------------------\nvar Err, SLog, Strength, Validate, _, async, mongoose, schema;\n\n_ = __webpack_require__(/*! lodash */ \"lodash\");\n\nasync = __webpack_require__(/*! async */ \"async\");\n\nmongoose = __webpack_require__(/*! mongoose */ \"mongoose\");\n\nErr = __webpack_require__(/*! ../../error */ \"./src/server/routers/error.coffee\");\n\nValidate = __webpack_require__(/*! ../../validate */ \"./src/server/routers/validate.coffee\");\n\n//-------------------------------------------------------------------------------\n// Models\n//-------------------------------------------------------------------------------\nStrength = mongoose.model('strength');\n\nSLog = mongoose.model('slog');\n\n//-------------------------------------------------------------------------------\n// Schema for POST and PUT validation\n//-------------------------------------------------------------------------------\nschema = {\n  date: [\n    {\n      method: 'isDate'\n    }\n  ],\n  name: [\n    {\n      method: 'isLength',\n      options: {\n        min: 1,\n        max: 25\n      }\n    }\n  ],\n  note: [\n    {\n      method: 'isLength',\n      options: {\n        min: 0,\n        max: 10\n      }\n    }\n  ],\n  count: [\n    {\n      method: 'isInt'\n    }\n  ],\n  body: [\n    {\n      method: 'isBoolean'\n    }\n  ]\n};\n\n//-------------------------------------------------------------------------------\n// List\n//   Return all strength exercises matching user id.\n//-------------------------------------------------------------------------------\nmodule.list = function(req, res) {\n  return async.waterfall([\n    function(callback) {\n      Strength.find({\n        user: req.session.passport.user\n      }).sort({\n        date: -1\n      }).lean().exec(function(err,\n    strengths) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    strengths);\n      });\n    }\n  ], function(err, strengths) {\n    // Response error status and text.\n    if (err) {\n      res.status(400).json(err);\n    }\n    return res.json(strengths);\n  });\n};\n\n//-------------------------------------------------------------------------------\n// Get\n//   Get a specific strength workout matching strength ID.\n//-------------------------------------------------------------------------------\nmodule.get = function(req, res) {\n  return async.waterfall([\n    function(callback) {\n      Strength.findOne({\n        _id: req.params.sid\n      }).exec(function(err,\n    strength) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    strength);\n      });\n    }\n  ], function(err, strength) {\n    // Response error status and text.\n    if (err) {\n      res.status(400).json(err);\n    }\n    return res.json(strength);\n  });\n};\n\n//-------------------------------------------------------------------------------\n// Post\n//   Create a new strength exercise.\n//-------------------------------------------------------------------------------\nmodule.post = function(req, res) {\n  async.waterfall([\n    function(callback) {\n      return Validate.isValid(req.body,\n    schema,\n    callback);\n    },\n    function(callback) {\n      var error;\n      error = null;\n      if (req.body.muscle.length === 0) {\n        error = 'Select which muscle will be targeted';\n      }\n      if (error) {\n        return callback(error);\n      }\n      return callback(null);\n    },\n    function(callback) {\n      return Strength.create({\n        date: req.body.date,\n        name: req.body.name,\n        note: req.body.note,\n        muscle: req.body.muscle,\n        body: req.body.body,\n        user: req.session.passport.user\n      },\n    function(err,\n    strength) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    strength);\n      });\n    }\n  ], function(err, strength) {\n    // If Error occured, return error status and text.\n    if (err) {\n      res.status(400).json(err);\n    }\n    // If success return a 201 status code and json.\n    res.status(201).json(strength);\n  });\n};\n\n//-------------------------------------------------------------------------------\n// PUT\n//   Edit a new strength exercise.\n//-------------------------------------------------------------------------------\nmodule.put = function(req, res) {\n  return async.waterfall([\n    function(callback) {\n      return Validate.isValid(req.body,\n    schema,\n    callback);\n    },\n    function(callback) {\n      Strength.findById(req.params.sid,\n    function(err,\n    strength) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    strength);\n      });\n    },\n    function(strength,\n    callback) {\n      strength.date = req.body.date;\n      strength.name = req.body.name;\n      strength.note = req.body.note;\n      strength.muscle = req.body.muscle;\n      strength.body = req.body.body;\n      strength.save(function(err,\n    entry) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    entry);\n      });\n    }\n  ], function(err, entry) {\n    if (err) {\n      res.status(400).json(err);\n    }\n    // Return json if success.\n    return res.json(entry);\n  });\n};\n\n//-------------------------------------------------------------------------------\n// Log\n\n//   Get a list all slogs matching that strength exercise id.\n//-------------------------------------------------------------------------------\nmodule.log = function(req, res) {\n  return async.waterfall([\n    function(callback) {\n      SLog.find({\n        exercise: req.params.sid\n      }).sort({\n        date: -1\n      }).lean().exec(function(err,\n    slogs) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    slogs);\n      });\n    }\n  ], function(err, slogs) {\n    if (err) {\n      res.status(400).json(err);\n    }\n    return res.json(slogs);\n  });\n};\n\n//-------------------------------------------------------------------------------\n// Delete\n//   Delete a sConf record.\n//-------------------------------------------------------------------------------\nmodule.delete = function(req, res) {\n  return async.waterfall([\n    function(callback) {\n      Strength.findById(req.params.sid,\n    function(err,\n    strength) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    strength);\n      });\n    },\n    function(strength,\n    callback) {\n      // Remove all associated slogs.\n      SLog.remove({\n        exercise: strength.id\n      }).exec(function(err) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    strength);\n      });\n    },\n    function(strength,\n    callback) {\n      // Remove the actual sconf entry.\n      strength.remove(function(err) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null);\n      });\n    }\n  ], function(err) {\n    if (err) {\n      res.status(400).json(err);\n    }\n    res.sendStatus(204);\n  });\n};\n\n//-------------------------------------------------------------------------------\n// Exports\n//-------------------------------------------------------------------------------\nmodule.exports = module;\n\n//-------------------------------------------------------------------------------\n\n/* WEBPACK VAR INJECTION */}.call(this, __webpack_require__(/*! ./../../../../../node_modules/webpack/buildin/module.js */ \"./node_modules/webpack/buildin/module.js\")(module)))\n\n//# sourceURL=webpack:///./src/server/routers/main/strength/module.coffee?");

/***/ }),

/***/ "./src/server/routers/main/wlog/module.coffee":
/*!****************************************************!*\
  !*** ./src/server/routers/main/wlog/module.coffee ***!
  \****************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

eval("/* WEBPACK VAR INJECTION */(function(module) {//-------------------------------------------------------------------------------\n// Imports\n//-------------------------------------------------------------------------------\nvar WLog, _, async, mongoose;\n\n_ = __webpack_require__(/*! lodash */ \"lodash\");\n\nasync = __webpack_require__(/*! async */ \"async\");\n\nmongoose = __webpack_require__(/*! mongoose */ \"mongoose\");\n\n//-------------------------------------------------------------------------------\n// Models\n//-------------------------------------------------------------------------------\nWLog = mongoose.model('wlog');\n\n//-------------------------------------------------------------------------------\n// List\n//   Get all wlogs from this user.\n//-------------------------------------------------------------------------------\nmodule.list = function(req, res) {\n  return async.waterfall([\n    function(callback) {\n      WLog.find({\n        user: req.session.passport.user\n      }).lean().exec(function(err,\n    wlogs) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    wlogs);\n      });\n    }\n  ], function(err, documents) {\n    if (err) {\n      res.status(400).json(err);\n    }\n    return res.json(documents);\n  });\n};\n\n//-------------------------------------------------------------------------------\n// Get\n//   Get a specific wlogs with matching strengthID\n//-------------------------------------------------------------------------------\nmodule.get = function(req, res) {\n  return async.waterfall([\n    function(callback) {\n      WLog.find({\n        exercise: req.params.sid\n      }).lean().exec(function(err,\n    wlogs) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    wlogs);\n      });\n    }\n  ], function(err, documents) {\n    if (err) {\n      res.status(400).json(err);\n    }\n    return res.json(documents);\n  });\n};\n\n//-------------------------------------------------------------------------------\n// Post\n//   Create a new wlog. As well as updating the strength workout's last date.\n//-------------------------------------------------------------------------------\nmodule.post = function(req, res) {\n  async.waterfall([\n    function(callback) {\n      // Create a new wlog entry.\n      return WLog.create({\n        date: req.body.date,\n        note: req.body.note,\n        weight: req.body.weight,\n        user: req.session.passport.user\n      },\n    function(err,\n    wlog) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    wlog);\n      });\n    }\n  ], function(err, wlog) {\n    if (err) {\n      res.status(400).json(err);\n    }\n    res.status(201).json(wlog);\n  });\n};\n\n//-------------------------------------------------------------------------------\n// Put\n//   Edit a wlog record.\n//-------------------------------------------------------------------------------\nmodule.put = function(req, res) {\n  return async.waterfall([\n    function(callback) {\n      WLog.findById(req.params.sid,\n    function(err,\n    wlog) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    wlog);\n      });\n    },\n    function(wlog,\n    callback) {\n      wlog.date = req.body.date;\n      wlog.muscle = req.body.muscle;\n      wlog.note = req.body.note;\n      wlog.session = req.body.session;\n      wlog.save(function(err,\n    wlog) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    wlog);\n      });\n    }\n  ], function(err, document) {\n    if (err) {\n      res.status(400).json(err);\n    }\n    // Return json if success.\n    return res.json(document);\n  });\n};\n\n//-------------------------------------------------------------------------------\n// Delete\n//   Delete a wlog record.\n//-------------------------------------------------------------------------------\nmodule.delete = function(req, res) {\n  return async.waterfall([\n    function(callback) {\n      WLog.findById(req.params.sid,\n    function(err,\n    wlog) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    wlog);\n      });\n    },\n    function(wlog,\n    callback) {\n      wlog.remove(function(err) {\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null);\n      });\n    }\n  ], function(err) {\n    if (err) {\n      res.status(202).json(err);\n    }\n    res.sendStatus(204);\n  });\n};\n\n//-------------------------------------------------------------------------------\n// Exports\n//-------------------------------------------------------------------------------\nmodule.exports = module;\n\n//-------------------------------------------------------------------------------\n\n/* WEBPACK VAR INJECTION */}.call(this, __webpack_require__(/*! ./../../../../../node_modules/webpack/buildin/module.js */ \"./node_modules/webpack/buildin/module.js\")(module)))\n\n//# sourceURL=webpack:///./src/server/routers/main/wlog/module.coffee?");

/***/ }),

/***/ "./src/server/routers/module.coffee":
/*!******************************************!*\
  !*** ./src/server/routers/module.coffee ***!
  \******************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

eval("//-------------------------------------------------------------------------------\n// Exports\n//-------------------------------------------------------------------------------\nmodule.exports.indexRouter = __webpack_require__(/*! ./index/module */ \"./src/server/routers/index/module.coffee\");\n\nmodule.exports.mainRouter = __webpack_require__(/*! ./main/module */ \"./src/server/routers/main/module.coffee\");\n\nmodule.exports.userRouter = __webpack_require__(/*! ./user/module */ \"./src/server/routers/user/module.coffee\");\n\n//-------------------------------------------------------------------------------\n\n\n//# sourceURL=webpack:///./src/server/routers/module.coffee?");

/***/ }),

/***/ "./src/server/routers/user/account/module.coffee":
/*!*******************************************************!*\
  !*** ./src/server/routers/user/account/module.coffee ***!
  \*******************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

eval("/* WEBPACK VAR INJECTION */(function(module) {//-------------------------------------------------------------------------------\n// Imports\n//-------------------------------------------------------------------------------\nvar Image, User, WLog, async, moment, mongoose, validator;\n\nmoment = __webpack_require__(/*! moment */ \"moment\");\n\nasync = __webpack_require__(/*! async */ \"async\");\n\nmongoose = __webpack_require__(/*! mongoose */ \"mongoose\");\n\nvalidator = __webpack_require__(/*! validator */ \"validator\");\n\n//-------------------------------------------------------------------------------\n// Models\n//-------------------------------------------------------------------------------\nUser = mongoose.model('user');\n\nWLog = mongoose.model('wlog');\n\nImage = mongoose.model('image');\n\n//-------------------------------------------------------------------------------\n// GET\n//-------------------------------------------------------------------------------\nmodule.get = function(req, res) {\n  var result;\n  result = {};\n  return async.waterfall([\n    function(callback) {\n      var id;\n      id = req.session.passport.user;\n      if (id === void 0) {\n        return callback('No Session ID');\n      }\n      User.findOne({\n        _id: id\n      }).exec(function(err,\n    user) {\n        if (user === null) {\n          return callback('No user found');\n        }\n        if (err) {\n          return callback(err);\n        }\n        result = user.getPublicFields();\n        return callback(null);\n      });\n    }\n  ], function(err) {\n    if (err) {\n      res.status(400).json(err);\n    } else {\n      res.status(200).json(result);\n    }\n  });\n};\n\n//-------------------------------------------------------------------------------\n// Exports\n//-------------------------------------------------------------------------------\nmodule.exports = module;\n\n//-------------------------------------------------------------------------------\n\n/* WEBPACK VAR INJECTION */}.call(this, __webpack_require__(/*! ./../../../../../node_modules/webpack/buildin/module.js */ \"./node_modules/webpack/buildin/module.js\")(module)))\n\n//# sourceURL=webpack:///./src/server/routers/user/account/module.coffee?");

/***/ }),

/***/ "./src/server/routers/user/module.coffee":
/*!***********************************************!*\
  !*** ./src/server/routers/user/module.coffee ***!
  \***********************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

eval("//-------------------------------------------------------------------------------\n// Imports\n//-------------------------------------------------------------------------------\nvar Account, Profile, User, _, express, i, index, len, middleware, middlewares, ref, router, url;\n\n_ = __webpack_require__(/*! lodash */ \"lodash\");\n\nexpress = __webpack_require__(/*! express */ \"express\");\n\nmiddleware = __webpack_require__(/*! ../../middleware */ \"./src/server/middleware.coffee\");\n\nrouter = express.Router();\n\n//-------------------------------------------------------------------------------\n// Route Middleware\n//-------------------------------------------------------------------------------\nmiddlewares = [middleware.isAuthenticated];\n\n//-------------------------------------------------------------------------------\n// Path Routes.\n//   Pass index to all routes.\n//-------------------------------------------------------------------------------\nindex = function(req, res, next) {\n  res.render('index');\n};\n\nref = ['/account', '/profile'];\nfor (i = 0, len = ref.length; i < len; i++) {\n  url = ref[i];\n  router.use(url, express.static(__dirname + '/dist'));\n  router.get('/account', middlewares, index);\n}\n\n//-------------------------------------------------------------------------------\n// Import Routes\n//-------------------------------------------------------------------------------\nUser = __webpack_require__(/*! ./user/module */ \"./src/server/routers/user/user/module.coffee\");\n\nAccount = __webpack_require__(/*! ./account/module */ \"./src/server/routers/user/account/module.coffee\");\n\nProfile = __webpack_require__(/*! ./profile/module */ \"./src/server/routers/user/profile/module.coffee\");\n\n//-------------------------------------------------------------------------------\n// API Routes for Resources.\n//-------------------------------------------------------------------------------\nrouter.get('/api/user', middlewares, User.get);\n\nrouter.get('/api/account', middlewares, Account.get);\n\nrouter.get('/api/profile', middlewares, Profile.get);\n\nrouter.put('/api/profile', middlewares, Profile.put);\n\n//-------------------------------------------------------------------------------\n// Exports\n//-------------------------------------------------------------------------------\nmodule.exports = router;\n\n//-------------------------------------------------------------------------------\n\n\n//# sourceURL=webpack:///./src/server/routers/user/module.coffee?");

/***/ }),

/***/ "./src/server/routers/user/profile/module.coffee":
/*!*******************************************************!*\
  !*** ./src/server/routers/user/profile/module.coffee ***!
  \*******************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

eval("/* WEBPACK VAR INJECTION */(function(module) {//-------------------------------------------------------------------------------\n// Imports\n//-------------------------------------------------------------------------------\nvar Image, User, WLog, async, moment, mongoose, validator;\n\nmoment = __webpack_require__(/*! moment */ \"moment\");\n\nasync = __webpack_require__(/*! async */ \"async\");\n\nmongoose = __webpack_require__(/*! mongoose */ \"mongoose\");\n\nvalidator = __webpack_require__(/*! validator */ \"validator\");\n\n//-------------------------------------------------------------------------------\n// Models\n//-------------------------------------------------------------------------------\nUser = mongoose.model('user');\n\nWLog = mongoose.model('wlog');\n\nImage = mongoose.model('image');\n\n//-------------------------------------------------------------------------------\n// GET\n//-------------------------------------------------------------------------------\nmodule.get = function(req, res) {\n  var result;\n  result = {};\n  return async.waterfall([\n    function(callback) {\n      var id;\n      id = req.session.passport.user;\n      if (id === void 0) {\n        return callback('No Session ID');\n      }\n      User.findOne({\n        _id: id\n      }).exec(function(err,\n    user) {\n        if (user === null) {\n          return callback('No user found');\n        }\n        if (err) {\n          return callback(err);\n        }\n        result.user = user.getPublicFields();\n        return callback(null);\n      });\n    },\n    function(callback) {\n      Image.findOne({\n        user: req.session.passport.user,\n        imageType: 'profile'\n      }).exec(function(err,\n    image) {\n        if (err) {\n          return callback(err);\n        }\n        result.image = image;\n        return callback(null);\n      });\n    }\n  ], function(err) {\n    if (err) {\n      res.status(400).json(err);\n    } else {\n      res.status(200).json(result);\n    }\n  });\n};\n\n//-------------------------------------------------------------------------------\n// PUT\n//-------------------------------------------------------------------------------\nmodule.put = function(req, res) {\n  return async.waterfall([\n    function(callback) {\n      if (!validator.isAlpha(req.body.firstname)) {\n        return callback('Bad Firstname');\n      }\n      if (!validator.isAlpha(req.body.lastname)) {\n        return callback('Bad Lastname');\n      }\n      return callback(null);\n    },\n    function(callback) {\n      var id;\n      id = req.session.passport.user;\n      if (id === void 0) {\n        return callback('No Session ID');\n      }\n      User.findOneAndUpdate({\n        _id: id\n      },\n    {\n        email: req.body.email,\n        firstname: req.body.firstname,\n        lastname: req.body.lastname,\n        height: req.body.height,\n        gender: req.body.gender,\n        birthday: req.body.birthday\n      },\n    function(err,\n    user) {\n        if (user === null) {\n          return callback('No user found');\n        }\n        if (err) {\n          return callback(err.message);\n        }\n        return callback(null,\n    user);\n      });\n    },\n    function(user,\n    callback) {\n      // Create a new wlog entry.\n      WLog.create({\n        date: moment(),\n        note: req.body.note,\n        weight: req.body.weight,\n        user: req.session.passport.user\n      },\n    function(err) {\n        if (err) {\n          return callback(err.errors);\n        }\n        return callback(null,\n    user);\n      });\n    },\n    function(user,\n    callback) {\n      if (req.body.data.length === 0) {\n        Image.findOneAndRemove({\n          user: req.session.passport.user,\n          imageType: 'profile'\n        },\n    function(err) {\n          if (err) {\n            return callback(err.errors);\n          }\n          return callback(null,\n    user);\n        });\n      } else {\n        Image.findOneAndUpdate({\n          user: req.session.passport.user,\n          imageType: 'profile'\n        },\n    {\n          uploadDate: moment(),\n          lastModified: req.body.lastModified,\n          lastModifiedDate: req.body.lastModifiedDate,\n          name: req.body.name,\n          size: req.body.size,\n          imageType: req.body.imageType,\n          type: req.body.type,\n          data: req.body.data,\n          user: req.session.passport.user\n        },\n    {\n          upsert: true\n        },\n    function(err) {\n          if (err) {\n            return callback(err.errors);\n          }\n          return callback(null,\n    user);\n        });\n      }\n    }\n  ], function(err, user) {\n    if (err) {\n      res.status(400).json(err);\n    } else {\n      res.status(200).json(user.getPublicFields());\n    }\n  });\n};\n\n//-------------------------------------------------------------------------------\n// Exports\n//-------------------------------------------------------------------------------\nmodule.exports = module;\n\n//-------------------------------------------------------------------------------\n\n/* WEBPACK VAR INJECTION */}.call(this, __webpack_require__(/*! ./../../../../../node_modules/webpack/buildin/module.js */ \"./node_modules/webpack/buildin/module.js\")(module)))\n\n//# sourceURL=webpack:///./src/server/routers/user/profile/module.coffee?");

/***/ }),

/***/ "./src/server/routers/user/user/module.coffee":
/*!****************************************************!*\
  !*** ./src/server/routers/user/user/module.coffee ***!
  \****************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

eval("//-------------------------------------------------------------------------------\n// Imports\n//-------------------------------------------------------------------------------\nvar User, async, mongoose;\n\nasync = __webpack_require__(/*! async */ \"async\");\n\nmongoose = __webpack_require__(/*! mongoose */ \"mongoose\");\n\n//-------------------------------------------------------------------------------\n// Models\n//-------------------------------------------------------------------------------\nUser = mongoose.model('user');\n\n//-------------------------------------------------------------------------------\n// GET\n//-------------------------------------------------------------------------------\nexports.get = function(req, res) {\n  return async.waterfall([\n    function(callback) {\n      var id;\n      id = req.session.passport.user;\n      if (id === void 0) {\n        return callback('No Session ID');\n      }\n      User.findOne({\n        _id: id\n      }).exec(function(err,\n    user) {\n        if (user === null) {\n          return callback('No user found');\n        }\n        if (err) {\n          return callback(err);\n        }\n        return callback(null,\n    user.getPublicFields());\n      });\n    }\n  ], function(err, user) {\n    if (err) {\n      res.status(400).json(err);\n    } else {\n      res.status(200).json(user);\n    }\n  });\n};\n\n//-------------------------------------------------------------------------------\n\n\n//# sourceURL=webpack:///./src/server/routers/user/user/module.coffee?");

/***/ }),

/***/ "./src/server/routers/validate.coffee":
/*!********************************************!*\
  !*** ./src/server/routers/validate.coffee ***!
  \********************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

eval("//-------------------------------------------------------------------------------\n// Imports\n//-------------------------------------------------------------------------------\nvar Methods, _, isValid, sanitize, validator;\n\n_ = __webpack_require__(/*! lodash */ \"lodash\");\n\nvalidator = __webpack_require__(/*! validator */ \"validator\");\n\n//-------------------------------------------------------------------------------\n// Types of methods available to validate.\n//-------------------------------------------------------------------------------\nMethods = [\n  {\n    method: 'isBoolean',\n    text: 'not a boolean format'\n  },\n  {\n    method: 'isDate',\n    text: 'not a date format'\n  },\n  {\n    method: 'isFloat',\n    text: 'not a decimal number'\n  },\n  {\n    method: 'isInt',\n    text: 'not a number'\n  },\n  {\n    method: 'isEmail',\n    text: 'incorrect email format'\n  },\n  {\n    method: 'isLength',\n    text: 'incorrect length'\n  }\n];\n\n//-------------------------------------------------------------------------------\n// Sanitize given value\n//-------------------------------------------------------------------------------\nsanitize = function(str) {\n  str = validator.blacklist(str, ['\\\\', '/', ';', '\"', '{', '}']);\n  str = validator.escape(str);\n  str = validator.trim(str);\n  return str;\n};\n\n//-------------------------------------------------------------------------------\n// Validate request\n//-------------------------------------------------------------------------------\nisValid = function(requestBody, schema, callback) {\n  var bodyKey, bodyValue, i, len, methods, obj, passed;\n  for (bodyKey in requestBody) {\n    bodyValue = requestBody[bodyKey];\n    // Return false if req body is not in schema to validate.\n    methods = schema[bodyKey];\n    if (!methods) {\n      // If key is is unknown, then just skip validation on it.\n      return callback(null);\n    }\n    // Sanitize input before proceeding.\n    if (typeof bodyValue === 'string') {\n      requestBody[bodyKey] = bodyValue = sanitize(bodyValue);\n    } else {\n      bodyValue = bodyValue.toString();\n    }\n    for (i = 0, len = methods.length; i < len; i++) {\n      obj = methods[i];\n      passed = validator[obj.method](bodyValue, obj.options);\n      if (!passed) {\n        return callback(`${bodyKey} - ${(_.find(Methods, {\n          method: obj.method\n        }).text)}.`);\n      }\n    }\n  }\n  return callback(null);\n};\n\n//-------------------------------------------------------------------------------\n// Exports\n//-------------------------------------------------------------------------------\nmodule.exports.isValid = isValid;\n\n//-------------------------------------------------------------------------------\n\n\n//# sourceURL=webpack:///./src/server/routers/validate.coffee?");

/***/ }),

/***/ "async":
/*!************************!*\
  !*** external "async" ***!
  \************************/
/*! no static exports found */
/***/ (function(module, exports) {

eval("module.exports = require(\"async\");\n\n//# sourceURL=webpack:///external_%22async%22?");

/***/ }),

/***/ "body-parser":
/*!******************************!*\
  !*** external "body-parser" ***!
  \******************************/
/*! no static exports found */
/***/ (function(module, exports) {

eval("module.exports = require(\"body-parser\");\n\n//# sourceURL=webpack:///external_%22body-parser%22?");

/***/ }),

/***/ "compression":
/*!******************************!*\
  !*** external "compression" ***!
  \******************************/
/*! no static exports found */
/***/ (function(module, exports) {

eval("module.exports = require(\"compression\");\n\n//# sourceURL=webpack:///external_%22compression%22?");

/***/ }),

/***/ "connect-mongo":
/*!********************************!*\
  !*** external "connect-mongo" ***!
  \********************************/
/*! no static exports found */
/***/ (function(module, exports) {

eval("module.exports = require(\"connect-mongo\");\n\n//# sourceURL=webpack:///external_%22connect-mongo%22?");

/***/ }),

/***/ "cookie-parser":
/*!********************************!*\
  !*** external "cookie-parser" ***!
  \********************************/
/*! no static exports found */
/***/ (function(module, exports) {

eval("module.exports = require(\"cookie-parser\");\n\n//# sourceURL=webpack:///external_%22cookie-parser%22?");

/***/ }),

/***/ "crypto":
/*!*************************!*\
  !*** external "crypto" ***!
  \*************************/
/*! no static exports found */
/***/ (function(module, exports) {

eval("module.exports = require(\"crypto\");\n\n//# sourceURL=webpack:///external_%22crypto%22?");

/***/ }),

/***/ "express":
/*!**************************!*\
  !*** external "express" ***!
  \**************************/
/*! no static exports found */
/***/ (function(module, exports) {

eval("module.exports = require(\"express\");\n\n//# sourceURL=webpack:///external_%22express%22?");

/***/ }),

/***/ "express-session":
/*!**********************************!*\
  !*** external "express-session" ***!
  \**********************************/
/*! no static exports found */
/***/ (function(module, exports) {

eval("module.exports = require(\"express-session\");\n\n//# sourceURL=webpack:///external_%22express-session%22?");

/***/ }),

/***/ "lodash":
/*!*************************!*\
  !*** external "lodash" ***!
  \*************************/
/*! no static exports found */
/***/ (function(module, exports) {

eval("module.exports = require(\"lodash\");\n\n//# sourceURL=webpack:///external_%22lodash%22?");

/***/ }),

/***/ "moment":
/*!*************************!*\
  !*** external "moment" ***!
  \*************************/
/*! no static exports found */
/***/ (function(module, exports) {

eval("module.exports = require(\"moment\");\n\n//# sourceURL=webpack:///external_%22moment%22?");

/***/ }),

/***/ "mongoose":
/*!***************************!*\
  !*** external "mongoose" ***!
  \***************************/
/*! no static exports found */
/***/ (function(module, exports) {

eval("module.exports = require(\"mongoose\");\n\n//# sourceURL=webpack:///external_%22mongoose%22?");

/***/ }),

/***/ "morgan":
/*!*************************!*\
  !*** external "morgan" ***!
  \*************************/
/*! no static exports found */
/***/ (function(module, exports) {

eval("module.exports = require(\"morgan\");\n\n//# sourceURL=webpack:///external_%22morgan%22?");

/***/ }),

/***/ "nodemailer":
/*!*****************************!*\
  !*** external "nodemailer" ***!
  \*****************************/
/*! no static exports found */
/***/ (function(module, exports) {

eval("module.exports = require(\"nodemailer\");\n\n//# sourceURL=webpack:///external_%22nodemailer%22?");

/***/ }),

/***/ "nodemailer-smtp-transport":
/*!********************************************!*\
  !*** external "nodemailer-smtp-transport" ***!
  \********************************************/
/*! no static exports found */
/***/ (function(module, exports) {

eval("module.exports = require(\"nodemailer-smtp-transport\");\n\n//# sourceURL=webpack:///external_%22nodemailer-smtp-transport%22?");

/***/ }),

/***/ "passport":
/*!***************************!*\
  !*** external "passport" ***!
  \***************************/
/*! no static exports found */
/***/ (function(module, exports) {

eval("module.exports = require(\"passport\");\n\n//# sourceURL=webpack:///external_%22passport%22?");

/***/ }),

/***/ "passport-facebook":
/*!************************************!*\
  !*** external "passport-facebook" ***!
  \************************************/
/*! no static exports found */
/***/ (function(module, exports) {

eval("module.exports = require(\"passport-facebook\");\n\n//# sourceURL=webpack:///external_%22passport-facebook%22?");

/***/ }),

/***/ "passport-google-oauth":
/*!****************************************!*\
  !*** external "passport-google-oauth" ***!
  \****************************************/
/*! no static exports found */
/***/ (function(module, exports) {

eval("module.exports = require(\"passport-google-oauth\");\n\n//# sourceURL=webpack:///external_%22passport-google-oauth%22?");

/***/ }),

/***/ "passport-local":
/*!*********************************!*\
  !*** external "passport-local" ***!
  \*********************************/
/*! no static exports found */
/***/ (function(module, exports) {

eval("module.exports = require(\"passport-local\");\n\n//# sourceURL=webpack:///external_%22passport-local%22?");

/***/ }),

/***/ "passport-twitter":
/*!***********************************!*\
  !*** external "passport-twitter" ***!
  \***********************************/
/*! no static exports found */
/***/ (function(module, exports) {

eval("module.exports = require(\"passport-twitter\");\n\n//# sourceURL=webpack:///external_%22passport-twitter%22?");

/***/ }),

/***/ "path":
/*!***********************!*\
  !*** external "path" ***!
  \***********************/
/*! no static exports found */
/***/ (function(module, exports) {

eval("module.exports = require(\"path\");\n\n//# sourceURL=webpack:///external_%22path%22?");

/***/ }),

/***/ "request":
/*!**************************!*\
  !*** external "request" ***!
  \**************************/
/*! no static exports found */
/***/ (function(module, exports) {

eval("module.exports = require(\"request\");\n\n//# sourceURL=webpack:///external_%22request%22?");

/***/ }),

/***/ "request-ip":
/*!*****************************!*\
  !*** external "request-ip" ***!
  \*****************************/
/*! no static exports found */
/***/ (function(module, exports) {

eval("module.exports = require(\"request-ip\");\n\n//# sourceURL=webpack:///external_%22request-ip%22?");

/***/ }),

/***/ "serve-favicon":
/*!********************************!*\
  !*** external "serve-favicon" ***!
  \********************************/
/*! no static exports found */
/***/ (function(module, exports) {

eval("module.exports = require(\"serve-favicon\");\n\n//# sourceURL=webpack:///external_%22serve-favicon%22?");

/***/ }),

/***/ "validator":
/*!****************************!*\
  !*** external "validator" ***!
  \****************************/
/*! no static exports found */
/***/ (function(module, exports) {

eval("module.exports = require(\"validator\");\n\n//# sourceURL=webpack:///external_%22validator%22?");

/***/ })

/******/ });