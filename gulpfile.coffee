#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

gulp        = require 'gulp'
webpack     = require 'webpack'
path        = require 'path'
read        = require 'read-file'
runSequence = require 'run-sequence'

#-------------------------------------------------------------------------------
# Gulp Plugins
#-------------------------------------------------------------------------------

# Utilities

size       = require 'gulp-size'
coffee     = require 'gulp-coffee'
gutil      = require 'gulp-util'
shell      = require 'gulp-shell'
inject     = require 'gulp-inject'
jade       = require 'gulp-jade'

# Builder

concat     = require 'gulp-concat'
less       = require 'gulp-less'
livereload = require 'gulp-livereload'
nodemon    = require 'gulp-nodemon'
html2jade  = require 'gulp-html2jade'

# Lint

coffeeLint = require 'gulp-coffeelint'
lessLint   = require 'gulp-recess'

# Minify

minifyJS   = require 'gulp-minify'
minifyCSS  = require 'gulp-cssnano'

#-------------------------------------------------------------------------------
# Config Variable
#-------------------------------------------------------------------------------

Production = false

#-------------------------------------------------------------------------------
# Javascript minify
#-------------------------------------------------------------------------------

gulp.task 'toggle:production', (callback) ->
  DEVELOPMENT = false
  callback
  return

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
  return gulp.src('./static/style.css')
  .pipe(minifyCSS
      discardComments:
        removeAll: true
    )
  .pipe(gulp.dest('static'))

#-------------------------------------------------------------------------------
# Coffee script Lint
#-------------------------------------------------------------------------------

gulp.task 'coffeelint', ->
  gulp.src([
    './server/**/*.coffee'
    './clientside/**/*.coffee'
  ])
  .pipe(coffeeLint null,
    'max_line_length':
      level: 'ignore'
  )
  .pipe(coffeeLint.reporter('coffeelint-stylish'))
  return

#-------------------------------------------------------------------------------
# Less Lint
#-------------------------------------------------------------------------------

gulp.task 'lesslint', ->
  gulp.src('./clientside/styles/less/application.less')
  .pipe(lessLint
    noIDs:               false
    strictPropertyOrder: false
    noOverqualifying:    false
  )
  .pipe(lessLint.reporter())
  return

#-------------------------------------------------------------------------------
# Server Coffee to JavaScript
#-------------------------------------------------------------------------------

gulp.task 'coffee:to:js:server', ->
  return gulp.src('./server/app.coffee')
  .pipe(
    coffee(bare: true)
    .on('error', gutil.log)
  )
  .pipe gulp.dest('./server')

#-------------------------------------------------------------------------------
# Client JavaScripts
#
#  - Call webpack to bundle all our javascripts files to
#    one javascript file, bundle.js.
#-------------------------------------------------------------------------------

gulp.task 'js:bundle', (callback) ->

  options =

    entry: [
      './clientside/src/entry.coffee'
    ]

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
        loader: "imports?$=jquery"
      ,
        test: /jquery/
        loader: "imports?jQuery=jquery"
      ,
        test: /bootstrap/
        loader: "imports?jQuery=jquery"
      ,
        test: /drawer/
        loader: "imports?IScroll=iscroll"
      ,
        test: /timeentry.js/
        loader: "imports?JQPlugin=JQPlugin"
      ,
        test: /backbone./
        loader: "imports?Backbone=backbone"
      ,
        test: /backbone.modal-bundled/
        loader: "imports?marionette=marionette"
      ]

    # Absolute path is used and not relative path.
    # had an error where module index.js could not be found.

    resolveLoader: {
      root: path.join(__dirname, 'node_modules')
    }

    resolve:
      root: './clientside'
      alias:

        underscore:                 'scripts/underscore.js'
        lodash:                     'scripts/lodash.js'
        moment:                     'scripts/moment.js'
        backbone:                   'scripts/backbone.js'
        'backbone.paginator':       'scripts/backbone.paginator.js'
        'backbone.modal':           'scripts/backbone.modal-bundled.js'
        'backbone.stickit':         'scripts/backbone.stickit.js'
        'backbone.validation':      'scripts/backbone.validation.js'
        'backbone.radio':           'scripts/backbone.radio.js'
        'socket.io':                'scripts/socket.io.js'
        marionette:                 'scripts/backbone.marionette.js'
        async:                      'scripts/async.js'
        highcharts:                 'scripts/highcharts.js'
        highstock:                  'scripts/highstock.js'
        bootstrap:                  'scripts/bootstrap.js'
        'bootstrap.validator':      'scripts/bootstrap.validator.js'
        jquery:                     'scripts/jquery.js'
        'jquery.ui':                'scripts/jquery-ui.js'
        mmenu:                      'scripts/jquery.mmenu.all.min.js'
        touchspin:                  'scripts/jquery.bootstrap-touchspin.js'
        multiselect:                'scripts/jquery.bootstrap-multiselect.js'
        datepicker:                 'scripts/jquery.bootstrap-datepicker.js'
        JQPlugin:                   'scripts/jquery.plugin.js'
        'bootstrap.datetimepicker': 'scripts/bootstrap-datetimepicker.min.js'
        'bootstrap.paginate':       'scripts/bootstrap.paginate.js'
        toastr:                     'scripts/toastr.js'
        fullcalendar:               'scripts/fullcalendar.js'

      extensions: [
        ''
        '.webpack.js'
        '.web.js'
        '.js'
        '.coffee'
      ]

      # XXX plugins not working to expose $
      plugins: [
        new webpack.ProvidePlugin({
          $: 'jquery',
        })
      ]

  webpack options, (err, stats) =>
    if err
      throw new PluginError('webpack', err)
    #log '[webpack]', stats.toString(colors: true)

    livereload.reload()

    callback null
    return

  return

#-------------------------------------------------------------------------------
# Compile CSS
#
#   Compile style.css and move to public folder.
#   Be sure to compile our css last so our css will have
#   priority over the others.
#-------------------------------------------------------------------------------

gulp.task 'css:concat', ->

  return gulp.src([

    './clientside/styles/css/bootstrap.css'
    './clientside/styles/css/bootstrap-theme.css'
    './clientside/styles/css/font-awesome.css'
    './clientside/styles/css/jquery.mmenu.all.css'
    './clientside/styles/css/jquery.bootstrap-touchspin.css'
    './clientside/styles/css/bootstrap-multiselect.css'
    './clientside/styles/css/bootstrap-datepicker.css'
    './clientside/styles/css/bootstrap-datetimepicker.min.css'
    './clientside/styles/css/jquery.timeentry.css'
    './clientside/styles/css/jquery-ui.css'
    './clientside/styles/css/toastr.css'
    './clientside/styles/css/spinkit.css'
    './clientside/styles/css/fullcalendar.css'

    './clientside/styles/bootstrap.custom.css'
    './clientside/styles/application.css'
  ])
  .pipe(concat('style.css'))
  .pipe gulp.dest('./static/')
  .pipe(livereload())

#-------------------------------------------------------------------------------
# Compile Less
#
#   Less to css.
#-------------------------------------------------------------------------------

gulp.task 'less:to:css', ->
  return gulp.src([ './clientside/styles/less/*' ])
  .pipe less()
  .pipe gulp.dest('./clientside/styles/')

#-------------------------------------------------------------------------------
# Move Fonts to public folder.
#-------------------------------------------------------------------------------

gulp.task 'fonts', ->
  return gulp.src([ './src/fonts/*' ])
  .pipe gulp.dest('./public/fonts/')

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

  livereload.listen
    start: true

  # Watch for change and re compile.

  gulp.watch [
    './server/**'
  ], [
    'compile:server:js'
  ]

  gulp.watch [
    './clientside/styles/css/**',
    './clientside/styles/**'
  ], [
    'compile:css'
  ]

  gulp.watch [
    './clientside/src/**'
  ], [
    'compile:client:js'
  ]

  return

#-------------------------------------------------------------------------------
# Report size
#-------------------------------------------------------------------------------

gulp.task 'report:size', (callback) ->

  gulp.src('./static/bundle.js')
  .pipe size
    title: '----- bundle(minified).js -----'
    gzip: true
  .pipe(gulp.dest('static/bungle-min.js'))

  gulp.src('./static/style.css')
  .pipe size
    title: '----- style.css -----'
    gzip: true
  .pipe(gulp.dest('static'))

  callback
  return

#-------------------------------------------------------------------------------
# Gzip Size
#   Report to console file sizes.
#-------------------------------------------------------------------------------

reportGzipSize = ->

  gulp.src('./static/bundle.js')
  .pipe size
    title: '----- bundle(minified).js -----'
    gzip: true
  .pipe(gulp.dest('static/bungle-min.js'))

  gulp.src('./static/style.css')
  .pipe size
    title: '----- style.css -----'
    gzip: true
  .pipe(gulp.dest('static'))

  return

#-------------------------------------------------------------------------------
# Perform shell commands.
#   Look up npm packages version.
#-------------------------------------------------------------------------------

gulp.task 'shell:npm:version', shell.task [
    'ncu --packageFile ./package.json > console.txt'
  ],
    verbose: true
    timeout: 60000

#-------------------------------------------------------------------------------
# Console out log file.
#-------------------------------------------------------------------------------

gulp.task 'read:log', ->
  read 'console.txt', 'utf8',(err, buffer) ->
    gutil.log gutil.colors.yellow buffer
    return
  return

#-------------------------------------------------------------------------------
# Inject either bundle or bundle minified to index.html
#-------------------------------------------------------------------------------

gulp.task 'inject:js', ->

  sources = gulp.src(['static/bundle.js'])
  sources = gulp.src(['static/bundle-min.js']) if Production

  options =
    ignorePath: 'static'
    addRootSlash: false

  return gulp.src('static/index.html')
  .pipe(inject(sources,options))
  .pipe gulp.dest('./static')

#-------------------------------------------------------------------------------
# Convert index.html to useable index.jade.
#-------------------------------------------------------------------------------

gulp.task 'html:to:jade', ->
  return gulp.src('static/index.html')
  .pipe(html2jade())
  .pipe(gulp.dest('static'))

#-------------------------------------------------------------------------------
# Set production variable to true.
#-------------------------------------------------------------------------------

gulp.task 'production:variable', ->
  Production = true
  return

#-------------------------------------------------------------------------------
# Chained tasks.
#-------------------------------------------------------------------------------

gulp.task 'compile:server:js', [
  'coffee:to:js:server'
]

gulp.task 'compile:css', [
  'lesslint'
  'less:to:css'
  'css:concat'
]

gulp.task 'compile:client:js', [
  'coffee:to:js:server'
  'js:bundle'
]

gulp.task 'minify', [
  'minify-css'
  'minify-js'
]

gulp.task 'compile:index', (callback) ->
  runSequence 'inject:js',
    'html:to:jade',
    callback
  return

# Production task to build and report app.

gulp.task 'production', (callback) ->
  runSequence 'production:variable',
    'compile:css',
    'compile:client:js',
    'minify',
    'compile:index',
    'shell:npm:version',
    'read:log',
    'report:size',
    callback
  return

# Default task use for development.

gulp.task 'default', (callback) ->
  runSequence 'nodemon',
    'coffeelint',
    'compile:client:js',
    'compile:server:js',
    'compile:css',
    'compile:index',
    'watch',
    callback
  return

#-------------------------------------------------------------------------------
