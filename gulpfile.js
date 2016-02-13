//--------------------------------------------------------------------------------
// Imports
//--------------------------------------------------------------------------------

var gulp    = require('gulp'),
    webpack = require('webpack');

//--------------------------------------------------------------------------------
// Gulp Plugins
//--------------------------------------------------------------------------------

var concat     = require('gulp-concat'),
    jshint     = require('gulp-jshint'),
    less       = require('gulp-less'),
    livereload = require('gulp-livereload'),
    nodemon    = require('gulp-nodemon');

//--------------------------------------------------------------------------------
// Gulp Utility Plugins
//--------------------------------------------------------------------------------

var PluginsError, colors, log, _ref;

_ref        = require('gulp-util'),
log         = _ref.log,
colors      = _ref.colors,
PluginError = _ref.PluginError;

//################################################################################
// -- TASKS --
//################################################################################

//--------------------------------------------------------------------------------
// Lint
//--------------------------------------------------------------------------------

gulp.task('lint', function() {
    return gulp.src('./src/client/*.js')
        .pipe(jshint())
        .pipe(jshint.reporter('jshint-stylish'))
        .pipe(jshint.reporter('fail'));
});

//--------------------------------------------------------------------------------
// Scripts
//
//  - Call webpack to bundle all our javascripts files to
//    one javascript file, bundle.js.
//--------------------------------------------------------------------------------

gulp.task('scripts', function (callback) {

    var options = {
        entry: [
            "./clientside/src/entry.coffee"
        ],
        output: {
            path:     "./static",
            filename: "bundle.js"
        },
        module:{
            loaders:[
                {
                    test: /\.coffee$/,
                    loader: "coffee-loader"
                },
                {
                    test: /\.jade$/,
                    loader: 'jade'
                }
            ]
        },
        resolve: {
            root: "./clientside",
            alias: {
                underscore:           "scripts/underscore.js",
                lodash:               "scripts/lodash.js",
                moment:               "scripts/moment.js",
                backbone:             "scripts/backbone.js",
                'backbone.paginator': "scripts/backbone.paginator.js",
                stickit:              "scripts/backbone.stickit.js",
                'socket.io':          "scripts/socket.io.js",
                marionette:           "scripts/backbone.marionette.js",
                jquery:               "scripts/jquery.js",
                mmenu:                "scripts/jquery.mmenu.min.all.js",
                bootstrap:            "scripts/bootstrap.js",
                async:                "scripts/async.js"
            },
            extensions:[
                '',
                '.webpack.js',
                '.web.js',
                '.js',
                '.coffee'
            ]
        }
    };

    webpack(options, function(err, stats){
        if(err){
            throw new PluginError('webpack', err);
        }

        log('[webpack]', stats.toString({
            colors:true
        }));

       callback();
    });
});

//--------------------------------------------------------------------------------
// Compile CSS
//--------------------------------------------------------------------------------

gulp.task('css', function () {

    // Compile style.css and move to public folder.
    gulp.src([
                // Jquery plugins.
                "./clientside/styles/css/jquery.mmenu.all.css",
                "./clientside/styles/css/jquery.mmenu.counters.css",
                "./clientside/styles/css/jquery.mmenu.footer.css",
                "./clientside/styles/css/jquery.mmenu.header.css",
                "./clientside/styles/css/jquery.mmenu.themes.css",

                // Bootstrap CSS.
                "./clientside/styles/bootstrap/css/bootstrap.css",
                "./clientside/styles/bootstrap/css/bootstrap-theme.css",

                // FontAwesome CSS.
                "./clientside/styles/css/font-awesome.css",

                // Application CSS.
                "./clientside/styles/application.css"
            ])
        .pipe(concat('style.css'))
        .pipe(gulp.dest('./static/'));

    /*
    // Move dependency maps for bootstrap to public folder.
    gulp.src([
                "./src/bootstrap/css/bootstrap-theme.css.map",
                "./src/bootstrap/css/bootstrap.css.map"
            ])
        .pipe(gulp.dest('./static/stylesheets/'));
        */
});

//--------------------------------------------------------------------------------
// Move Fonts to public folder.
//--------------------------------------------------------------------------------

gulp.task('fonts', function () {
    gulp.src([
        "./src/fonts/*"
    ])
    .pipe(gulp.dest('./public/fonts/'));
});

//--------------------------------------------------------------------------------
// Nodemon
//
//  Restarts server if any changes has been made to any javascript files.
//--------------------------------------------------------------------------------

gulp.task('nodemon', function () {
  nodemon({
        ext: 'html js coffee',
        env: {
                'NODE_ENV': 'development'
             }})
    .on('restart', function () {
      console.log('restarted!');
    });
});

//--------------------------------------------------------------------------------
// Watch
//
//  - Start Livereload server.
//  - Watch for changes to javascript files and recompile.
//  - Watch for changes to css files and recompile.
//--------------------------------------------------------------------------------

gulp.task('watch', function() {

    // Start livereload server at default port.

    livereload.listen({start:true});

    // Watch for change and re compile.

    gulp.watch('./clientside/**', ['compile:client']);

    // When compiling if finish, reload browser's page.

    gulp.watch('./static/**', ['page:reload']);
});

//--------------------------------------------------------------------------------
// PageReload
//--------------------------------------------------------------------------------

gulp.task('page:reload', function() {

    // Force a page reload.

    livereload.reload();
});

//--------------------------------------------------------------------------------
// Chained tasks.
//--------------------------------------------------------------------------------

gulp.task('all',['nodemon','lint', 'compile:client', 'fonts', 'watch']);

gulp.task('compile:client',['scripts', 'css']);

gulp.task('default',['nodemon','compile:client', 'watch']);

//--------------------------------------------------------------------------------
