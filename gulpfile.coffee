#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

gulp           = require 'gulp'
webpack        = require 'webpack'
path           = require 'path'
read           = require 'read-file'
runSequence    = require 'run-sequence'
pump           = require 'pump'
webpackOptions = require './webpack.config'

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

production = false

#-------------------------------------------------------------------------------
# Javascript minify
#-------------------------------------------------------------------------------

# XXX minify and uglify result in a hanged process when gulp.

gulp.task 'minify:js', (callback) ->
  pump([
    gulp.src('static/bundle.js')
    uglify()
    rename('bundle-min.js')
    gulp.dest('static')
  ], callback)
  return

#-------------------------------------------------------------------------------
# CSS minify
#-------------------------------------------------------------------------------

gulp.task 'minify:css', (callback) ->
  gulp.src('./static/style.css')
  .pipe(minifyCSS
      discardComments:
        removeAll: true
    )
  .pipe(gulp.dest('static'))
  callback()
  return

#-------------------------------------------------------------------------------
# Coffee script Lint
#-------------------------------------------------------------------------------

gulp.task 'coffeelint', (callback) ->
  gulp.src([
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

  callback()
  return

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

  webpack webpackOptions, (err) =>
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

#-------------------------------------------------------------------------------
# Page reload
#-------------------------------------------------------------------------------

gulp.task 'page:reload', (callback) ->
  livereload.reload()
  callback()
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
#  Only monitor files from the server directory. Nodemon will restart
#  the server on any file changes.
#-------------------------------------------------------------------------------


gulp.task 'nodemon', (callback) ->

  stream = nodemon
    script: 'server/app.coffee'
    monitor: ['server']
    ext:     'js html coffee'

  # XXX The page reload here does not work when server first starts.

  stream.on 'start', ->
    gulp.start('page:reload')
    return

  callback()

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
  ], ->
    runSequence 'lesslint',
      'compile:css',
      'page:reload'
    return

  gulp.watch [
    './clientside/src/**/*.coffee'
  ], ->
    runSequence 'compile:client:js',
      'page:reload'
    return

  gulp.watch [
    './clientside/src/**/*.jade'
  ], ->
    runSequence 'compile:client:js',
      'page:reload'
    return

  gulp.watch [
    './clientside/src/**/*.pug'
  ],  ->
    runSequence 'compile:client:js',
      'page:reload'
    return

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

  gulp.src('./static/bundle.js')
  .pipe size
    showFiles: true
    title: '----- bundle.js -----'
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
    callback
  return

gulp.task 'compile:css', (callback) ->
  runSequence 'less:to:css',
    'css:concat'
    callback
  return

gulp.task 'compile:client:js', (callback) ->
  if production
    runSequence 'js:bundle',
      'minify:js'
      callback
  else
    runSequence 'js:bundle',
      callback
  return

gulp.task 'compile:index', (callback) ->
  runSequence 'inject:js',
    'html:to:jade',
    callback
  return

gulp.task 'minify', (callback) ->
  if production
    runSequence 'minify:css',
      'minify:js',
      callback
  else
    callback()
  return

#-------------------------------------------------------------------------------
# Production task to build and report app.
#-------------------------------------------------------------------------------

gulp.task 'production', (callback) ->
  runSequence 'lint',
    'compile:css',
    'compile:client:js',
    'minify',
    'compile:index',
    #'shell:npm:version',
    'read:log',
    'report:size',
    callback
  return

#-------------------------------------------------------------------------------
# Default task use for development.
#-------------------------------------------------------------------------------

gulp.task 'default', (callback) ->
  runSequence 'lint',
    'compile:client:js',
    'compile:server:js',
    'compile:css',
    'compile:index',
    'watch',
    'nodemon',
    callback
  return

#-------------------------------------------------------------------------------
