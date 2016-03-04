#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

gulp    = require 'gulp'
webpack = require 'webpack'
path    = require 'path'

#-------------------------------------------------------------------------------
# Gulp Plugins
#-------------------------------------------------------------------------------

# Minify

minifyJS   = require 'gulp-minify'
minifyCSS  = require 'gulp-cssnano'

# Lint

coffeelint = require 'gulp-coffeelint'
csslint    = require 'gulp-csslint'

# Builder

concat     = require 'gulp-concat'
less       = require 'gulp-less'
livereload = require 'gulp-livereload'
nodemon    = require 'gulp-nodemon'

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
# Javascript minify
#-------------------------------------------------------------------------------

gulp.task 'minify-js', ->
  gulp.src('./static/bundle.js')
    .pipe(minifyJS())
    .pipe(gulp.dest('static'))
  return

#-------------------------------------------------------------------------------
# CSS minify
#-------------------------------------------------------------------------------

gulp.task 'minify-css', ->
  return gulp.src('./static/*.css')
    .pipe(minifyCSS())
    .pipe(gulp.dest('static'))

#-------------------------------------------------------------------------------
# Coffee script Lint
#-------------------------------------------------------------------------------

gulp.task 'coffeelint', ->
  gulp.src('./clientside/**/*.coffee')
    .pipe(coffeelint())
    .pipe(coffeelint.reporter('coffeelint-stylish'))
  return

#-------------------------------------------------------------------------------
# CSS Lint
#-------------------------------------------------------------------------------

gulp.task 'csslint', ->
  gulp.src('./clientside/styles/application.css')
    .pipe(csslint())
    .pipe(csslint.reporter());
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
    # Expose Backbone variable for files such as backbone.validation.

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
      ,
        test: /bootstrap/
        loader: "imports?jQuery=jquery"
      ,
        test: /timeentry.js/
        loader: "imports?JQPlugin=JQPlugin"
      ,
        test: /backbone./
        loader: "imports?Backbone=backbone"
      ]

    # Absolute path is used and not relative path.
    # had an error where module index.js could not be found.

    resolveLoader: {
      root: path.join(__dirname, 'node_modules')
    },

    resolve:
      root: './clientside'
      alias:

        underscore:            'scripts/underscore.js'
        lodash:                'scripts/lodash.js'
        moment:                'scripts/moment.js'
        backbone:              'scripts/backbone.js'
        'backbone.paginator':  'scripts/backbone.paginator.js'
        'backbone.stickit':    'scripts/backbone.stickit.js'
        'backbone.validation': 'scripts/backbone.validation.js'
        'socket.io':           'scripts/socket.io.js'
        marionette:            'scripts/backbone.marionette.js'
        async:                 'scripts/async.js'

        bootstrap:             'scripts/bootstrap.js'
        'bootstrap.validator': 'scripts/bootstrap.validator.js'
        jquery:                'scripts/jquery.js'
        mmenu:                 'scripts/jquery.mmenu.min.all.js'
        touchspin:             'scripts/jquery.bootstrap-touchspin.js'
        multiselect:           'scripts/jquery.bootstrap-multiselect.js'
        datepicker:            'scripts/jquery.bootstrap-datepicker.js'
        JQPlugin:              'scripts/jquery.plugin.js'
        timeentry:             'scripts/jquery.timeentry.js'
        timepicker:            'scripts/jquery.bootstrap-timepicker.js'

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
#   Compile style.css and move to public folder.
#   Be sure to compile our css last so our css will have
#   priority over the others.
#-------------------------------------------------------------------------------

gulp.task 'css', ->

  gulp.src([



    './clientside/styles/bootstrap/css/bootstrap.css'
    './clientside/styles/bootstrap/css/bootstrap-theme.css'

    './clientside/styles/css/font-awesome.css'
    './clientside/styles/css/jquery.mmenu.all.css'
    './clientside/styles/css/jquery.mmenu.counters.css'
    './clientside/styles/css/jquery.mmenu.footer.css'
    './clientside/styles/css/jquery.mmenu.header.css'
    './clientside/styles/css/jquery.mmenu.themes.css'
    './clientside/styles/css/jquery.bootstrap-touchspin.css'
    './clientside/styles/css/bootstrap-multiselect.css'
    './clientside/styles/css/bootstrap-datepicker.css'
    './clientside/styles/css/jquery.timeentry.css'
    './clientside/styles/css/timepicker.css'

    './clientside/styles/application.css'

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
  gulp.watch './clientside/**', [ 'compile:client']

  # When compiling if finish, reload browser's page.

  gulp.watch [
    './static/**'
    './views/**'
  ]

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

gulp.task 'minify', [
  'minify-css'
  'minify-js'
]

gulp.task 'compile:client', [
    'scripts'
    'css'
    'csslint'
    'coffeelint'
  ], ->
    livereload.reload()

gulp.task 'production', [
  'compile:client'
  'minify'
]

# Default task

gulp.task 'default', [
  'nodemon'
  'compile:client'
  'watch'
]

#-------------------------------------------------------------------------------
