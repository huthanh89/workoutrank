#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

gulp    = require 'gulp'
webpack = require 'webpack'
path    = require 'path'

#-------------------------------------------------------------------------------
# Gulp Plugins
#-------------------------------------------------------------------------------

concat     = require 'gulp-concat'
jshint     = require 'gulp-jshint'
less       = require 'gulp-less'
livereload = require 'gulp-livereload'
nodemon    = require 'gulp-nodemon'
coffeelint = require 'gulp-coffeelint'

#-------------------------------------------------------------------------------
# Gulp Utility Plugins
#-------------------------------------------------------------------------------

PluginsError = undefined
colors       = undefined
log          = undefined
_ref         = undefined
_ref         = require('gulp-util')
log          = _ref.log
colors       = _ref.colors
PluginError  = _ref.PluginError

###############################################################################
# -- TASKS --
###############################################################################

#-------------------------------------------------------------------------------
# Lint coffee script
#-------------------------------------------------------------------------------

gulp.task 'coffeelint', ->
#  gulp.src('./clientside/src/*.coffee')
  gulp.src('./clientside/**/*.coffee')
  .pipe(coffeelint())
  .pipe(coffeelint.reporter('coffeelint-stylish'))
  return

#-------------------------------------------------------------------------------
# Lint javascript
#-------------------------------------------------------------------------------

gulp.task 'lint', ->
  gulp.src('./clientside/*.js')
  .pipe(jshint())
  .pipe(jshint.reporter('jshint-stylish'))
  .pipe jshint.reporter('fail')
  return

#-------------------------------------------------------------------------------
# Scripts
#
#  - Call webpack to bundle all our javascripts files to
#    one javascript file, bundle.js.
#-------------------------------------------------------------------------------

gulp.task 'scripts', (callback) ->

  options =

    entry: [
      './clientside/src/entry.coffee' ]

    output:
      path:     './static'
      filename: 'bundle.js'

    # For files with jquery in the name, import 'jQuery' into it.

    module:
      loaders: [
        test:   /\.coffee$/
        loader: 'coffee-loader'
      ,
        test:   /\.jade$/
        loader: 'jade'
      ,
        test: /jquery/
        loader: "imports?jQuery=jquery"
      ]

    # Absolute path is used and not relative path.
    # had an error where module index.js could not be found.

    resolveLoader: {
      root: path.join(__dirname, 'node_modules')
    },

    resolve:
      root: './clientside'
      alias:

        underscore:           'scripts/underscore.js'
        lodash:               'scripts/lodash.js'
        moment:               'scripts/moment.js'
        backbone:             'scripts/backbone.js'
        'backbone.paginator': 'scripts/backbone.paginator.js'
        stickit:              'scripts/backbone.stickit.js'
        'socket.io':          'scripts/socket.io.js'
        marionette:           'scripts/backbone.marionette.js'
        async:                'scripts/async.js'

        bootstrap:            'scripts/bootstrap.js'
        jquery:               'scripts/jquery.js'
        mmenu:                'scripts/jquery.mmenu.min.all.js'
        touchspin:            'scripts/jquery.bootstrap-touchspin.js'

      extensions: [
        ''
        '.webpack.js'
        '.web.js'
        '.js'
        '.coffee'
      ]

  webpack options, (err, stats) ->
    if err
      throw new PluginError('webpack', err)
    log '[webpack]', stats.toString(colors: true)
    callback()
    return
  return

#-------------------------------------------------------------------------------
# Compile CSS
#-------------------------------------------------------------------------------

gulp.task 'css', ->
# Compile style.css and move to public folder.
  gulp.src([

    './clientside/styles/css/font-awesome.css'
    './clientside/styles/application.css'

    './clientside/styles/bootstrap/css/bootstrap.css'
    './clientside/styles/bootstrap/css/bootstrap-theme.css'

    './clientside/styles/css/jquery.mmenu.all.css'
    './clientside/styles/css/jquery.mmenu.counters.css'
    './clientside/styles/css/jquery.mmenu.footer.css'
    './clientside/styles/css/jquery.mmenu.header.css'
    './clientside/styles/css/jquery.mmenu.themes.css'
    './clientside/styles/css/jquery.bootstrap-touchspin.css'

  ]).pipe(concat('style.css')).pipe gulp.dest('./static/')

  ###
  // Move dependency maps for bootstrap to public folder.
  gulp.src([
              "./src/bootstrap/css/bootstrap-theme.css.map",
              "./src/bootstrap/css/bootstrap.css.map"
          ])
      .pipe(gulp.dest('./static/stylesheets/'));
  ###

  return

#-------------------------------------------------------------------------------
# Move Fonts to public folder.
#-------------------------------------------------------------------------------

gulp.task 'fonts', ->
  gulp.src([ './src/fonts/*' ]).pipe gulp.dest('./public/fonts/')
  return

#-------------------------------------------------------------------------------
# Nodemon
#
#  Restarts server if any changes has been made to any javascript files.
#-------------------------------------------------------------------------------

gulp.task 'nodemon', ->
  nodemon
    ext: 'html js coffee'
    env:
      'NODE_ENV': 'development'
  return

#-------------------------------------------------------------------------------
# Watch
#
#  - Start Livereload server.
#  - Watch for changes to javascript files and recompile.
#  - Watch for changes to css files and recompile.
#-------------------------------------------------------------------------------

gulp.task 'watch', ->

  # Start livereload server at default port.
  livereload.listen start: true

  # Watch for change and re compile.
  gulp.watch './clientside/**', [ 'compile:client' ]

  # When compiling if finish, reload browser's page.

  gulp.watch [
    './static/**'
    './views/**'
  ], [ 'page:reload' ]

  return

#-------------------------------------------------------------------------------
# PageReload
#   Force a page reload.
#-------------------------------------------------------------------------------

gulp.task 'page:reload', ->
  livereload.reload()
  return

#-------------------------------------------------------------------------------
# Chained tasks.
#-------------------------------------------------------------------------------

gulp.task 'all', [
  'nodemon'
  'lint'
  'compile:client'
  'fonts'
  'watch'
]

gulp.task 'compile:client', [
  'scripts'
  'css'
  'lint'
]

# Default task

gulp.task 'default', [
  'nodemon'
  'coffeelint'
  'compile:client'
  'watch'
]

#-------------------------------------------------------------------------------
