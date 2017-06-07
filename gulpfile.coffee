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
rename     = require 'gulp-rename'

# Builder

concat     = require 'gulp-concat'
less       = require 'gulp-less'
livereload = require 'gulp-livereload'
nodemon    = require 'gulp-nodemon'
html2jade  = require 'gulp-html2jade'
uglify     = require 'gulp-uglify'

# Lint

coffeeLint = require 'gulp-coffeelint'
lessLint   = require 'gulp-recess'
w3cjs      = require 'gulp-w3cjs'

# Minify

minifyJS   = require 'gulp-minify'
minifyCSS  = require 'gulp-cssnano'

#-------------------------------------------------------------------------------
# Set production flag to false when in development.
#-------------------------------------------------------------------------------

production = true

#-------------------------------------------------------------------------------
# Server process environment variable.
#-------------------------------------------------------------------------------

process.env.production = if production then 'production' else 'development'

#-------------------------------------------------------------------------------
# Javascript minify
#-------------------------------------------------------------------------------

# XXX minify and uglify result in a hanged process when gulp.

gulp.task 'minify-js', ->
  return gulp.src('./static/bundle.js')
  .pipe(uglify())
  #.pipe(minifyJS())
  .pipe(rename('bundle-min.js'))
  .pipe(gulp.dest('static'))

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
  return gulp.src([
    './server/**/*.coffee'
    './clientside/**/*.coffee'
  ])
  .pipe(coffeeLint null,
    'unused_variables':
      level: 'warn'
    'max_line_length':
      level: 'ignore'
  )
  .pipe(coffeeLint.reporter('coffeelint-stylish'))

#-------------------------------------------------------------------------------
# Less Lint
#-------------------------------------------------------------------------------

gulp.task 'lesslint', ->
  return gulp.src('./clientside/styles/less/application.less')
  .pipe(lessLint
    noIDs:               false
    strictPropertyOrder: false
    noOverqualifying:    false
  )
  .pipe(lessLint.reporter())

#-------------------------------------------------------------------------------
# Less Lint
#-------------------------------------------------------------------------------

gulp.task 'htmllint', ->
  return gulp.src('static/index.html')
  .pipe(w3cjs())
  .pipe(w3cjs.reporter())

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

  webpackPlugins = [
    new webpack.ProvidePlugin({
      $:      'jquery'
      jQuery: 'jquery'
    })
  ]

  ###
  # XXX Not yet tested. Bundle-min.js file size still look the same.

  if production
    webpackPlugins.push [
      new webpack.DefinePlugin({
        'process.env':
          NODE_ENV: 'production'
      })
      new webpack.optimize.DedupePlugin()
      new webpack.optimize.LimitChunkCountPlugin()
      new webpack.optimize.OccurrenceOrderPlugin()
      new webpack.optimize.UglifyJsPlugin()
    ]
###

  options =

    entry: [
      './clientside/src/entry.coffee'
    ]

    output:
      path:      path.join(__dirname, 'static')
      filename: 'bundle.js'

    module:

      rules: [
        test:   /\.coffee$/
        loader: 'coffee-loader'
      ,
        test:   /\.jade$/
        loader: 'jade-loader'
      ,
        test:   /\.pug$/
        loader: 'pug-loader'
      ]

    resolve:

      # Specified location of scripts.

      modules: [
        "node_modules"         # NPM modules
        "./clientside/scripts" # 3rd party local library
        "./clientside/src/lib" # Our local library
      ]

      alias:
        'backbone.paginator':       'backbone.paginator.js'
        'backbone.modal':           'backbone.modal-bundled.js'
        'backbone.validation':      'backbone.validation.js'
        'socket.io':                'socket.io.js'
        'highcharts-more':          'highcharts-more.js'
        highstock:                  'highstock.js'
        bootstrap:                  'bootstrap.js'
        'bootstrap.validator':      'bootstrap.validator.js'
        'jquery.ui':                'jquery-ui.js'
        mmenu:                      'jquery.mmenu.all.min.js'
        touchspin:                  'jquery.bootstrap-touchspin.js'
        multiselect:                'jquery.bootstrap-multiselect.js'
        datepicker:                 'jquery.bootstrap-datepicker.js'
        JQPlugin:                   'jquery.plugin.js'
        'bootstrap.datetimepicker': 'bootstrap.datetimepicker.js'
        'bootstrap.paginate':       'bootstrap.paginate.js'
        toastr:                     'toastr.js'
        fullcalendar:               'fullcalendar.js'
        sweetalert:                 'sweetalert.min.js'
        gauge:                      'gauge.js'
        waypoint:                   'jquery.waypoints.js'
        infinite:                   'jquery.infinite.js'

      # Resolve files ending with the following extension.

      extensions: [
        '.coffee'
        '.js'
      ]

    plugins: webpackPlugins

  webpack options, (err) =>
    if err
      throw new PluginError('webpack', err)
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
    './clientside/styles/css/sweetalert.css'

    './clientside/styles/bootstrap.custom.css'
    './clientside/styles/application.css'
  ])
  .pipe(concat('style.css'))
  .pipe gulp.dest('./static/')
#  .pipe(livereload())

#-------------------------------------------------------------------------------
# Page reload
#-------------------------------------------------------------------------------

gulp.task 'page:reload', ->
  livereload.reload()
  return

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
    script: 'server/app.coffee'
    ext: 'html js coffee'
    env:
      'NODE_ENV': 'development'
    task: 'page:reload'
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
    'coffeelint'
    'compile:server:js'
  ]

  gulp.watch [
    './clientside/styles/css/**',
    './clientside/styles/**'
  ], [
    'lesslint'
    'compile:css'
  ]

  gulp.watch [
    './clientside/src/**/*.coffee'
  ], [
    'coffeelint'
    'compile:client:js'
  ]

  gulp.watch [
    './clientside/src/**/*.jade'
  ], [
    'compile:client:js'
  ]

  gulp.watch [
    './clientside/src/**/*.pug'
  ], [
    'compile:client:js'
  ]

  return

#-------------------------------------------------------------------------------
# Report size
#-------------------------------------------------------------------------------

gulp.task 'report:size', (callback) ->

  gulp.src('./static/bundle-min.js')
  .pipe size
    showFiles: true
    title: '----- bundle(minified).js -----'
  .pipe(gulp.dest('static'))

  gulp.src('./static/style.css')
  .pipe size
    showFiles: true
    title: '----- style.css -----'
  .pipe(gulp.dest('static'))

  callback
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
  sources = gulp.src(['static/bundle-min.js']) if production

  options =
    ignorePath:  'static'
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
  production = true
  return

#-------------------------------------------------------------------------------
# Perform a production start with pm2
#-------------------------------------------------------------------------------

gulp.task 'start', shell.task [
  'pm2 start ./server/app.js && pm2 logs'
]

#-------------------------------------------------------------------------------
# Chained tasks.
#-------------------------------------------------------------------------------

gulp.task 'lint', [
 # 'htmllint'
  'coffeelint'
  'lesslint'
]

gulp.task 'compile:server:js', (callback) ->
  runSequence 'coffee:to:js:server',
    'page:reload',
    callback
  return

gulp.task 'compile:css', (callback) ->
  runSequence 'less:to:css',
    'css:concat'
    'page:reload',
    callback
  return

gulp.task 'compile:client:js', (callback) ->
  runSequence 'js:bundle',
    'page:reload',
    callback
  return

gulp.task 'minify', [
  'minify-css'
  'minify-js'
]

gulp.task 'compile:index', (callback) ->
  runSequence 'inject:js',
    'html:to:jade',
    callback
  return

#-------------------------------------------------------------------------------
# Production task to build and report app.
#-------------------------------------------------------------------------------

gulp.task 'production', (callback) ->
  runSequence 'production:variable',
    'lint',
    'compile:css',
    'compile:client:js',
    'minify',
    'compile:index',
    'shell:npm:version',
    'read:log',
    'report:size',
    callback
  return

#-------------------------------------------------------------------------------
# Task to just build scripts,
#-------------------------------------------------------------------------------

gulp.task 'build', (callback) ->
  runSequence 'lint',
    'compile:client:js',
    'compile:server:js',
    'compile:css',
    'compile:index',
    callback
  return

#-------------------------------------------------------------------------------
# Default task use for development.
#-------------------------------------------------------------------------------

gulp.task 'default', (callback) ->
  runSequence 'nodemon',
    'lint',
    'compile:client:js',
    'compile:server:js',
    'compile:css',
    'compile:index',
    'watch',
    callback
  return

#-------------------------------------------------------------------------------
