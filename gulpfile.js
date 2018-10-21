//-----------------------------------------------------------------------------//
// Import
//-----------------------------------------------------------------------------//

const _             = require ('lodash');
const gulp          = require('gulp');
const nodemon       = require('gulp-nodemon');
const webpack       = require('webpack-stream');
const livereload    = require('gulp-livereload');
const webpackConfig = require('./webpack.config');
const cleanCSS      = require('gulp-clean-css');
const rename        = require('gulp-rename');
const pug           = require('gulp-pug');
const less          = require('gulp-less');
const htmlmin       = require('gulp-htmlmin');
const imagemin      = require('gulp-imagemin');
const open          = require('gulp-open');
const concat        = require('gulp-concat');
const merge         = require('merge-stream');
const order         = require("gulp-order");
const coffee        = require('gulp-coffee');
const gutil         = require('gulp-util')

var nodeExternals = require('webpack-node-externals');


//-----------------------------------------------------------------------------//
// Tasks
//-----------------------------------------------------------------------------//

gulp.task('copy-webfonts', () => {
    return gulp.src('src/client/webfonts/*')
        .pipe(gulp.dest('dist/webfonts'));
});

gulp.task('minify-js', () => {

    let config = _.assignIn(webpackConfig, {
        mode: 'production'
    });

    return gulp.src(__filename)
        .pipe(webpack({
            config: config
        }))
        .pipe(rename('bundle.js'))
        .pipe(gulp.dest('dist/js'));
});

gulp.task('minify-css', () => {
    return gulp.src('dist/css/*.css')
        .pipe(cleanCSS({
            compatibility: 'ie8'
        }))
        .pipe(gulp.dest('dist/css'));
});

gulp.task('minify-html', () => {
    return  gulp.src('dist/index.html')
        .pipe(htmlmin({ 
            collapseWhitespace: true 
        }))
        .pipe(gulp.dest('dist'));
});

gulp.task('minify-img', () => {
    return  gulp.src('src/client/image/*')
    .pipe(imagemin([
        imagemin.gifsicle({
            interlaced: true
        }),
        imagemin.jpegtran({
            progressive: true
        }),
        imagemin.optipng({
            optimizationLevel: 7
        }),
        imagemin.svgo({
            plugins: [
                {removeViewBox: true},
                {cleanupIDs: false}
            ]
        })
    ]))
    .pipe(gulp.dest('dist/asset'));
});

gulp.task('compile-js', (cb) => {

    let config = _.assignIn(webpackConfig, {
        entry:  './src/client/js/index.coffee',
        mode:   'development',
        target: 'web'
    });

    let reload = function(){
        livereload.reload();
        cb();
    };

    gulp.src(__filename)
        .pipe(webpack({
            config: config
        }))
        .pipe(gulp.dest('dist/js')).on('end', reload);
});

gulp.task('compile-server', (cb) => {

    let config = _.assignIn(webpackConfig, {
        entry:  './src/server/app.coffee',
        mode:   'development',
        target: 'node',
        externals: [nodeExternals()],
        node: {
            __dirname: false
        }
    });
    
    let reload = function(){
        livereload.reload();
        cb();
    };

    gulp.src(__filename)
        .pipe(webpack({
            config: config
        }))
        .pipe(rename('server.js'))
        .pipe(gulp.dest('./')).on('end', reload);
});

gulp.task('compile-css', (cb) => {

    let cssStream = gulp.src('src/vendor/*.css')
        .pipe(concat("vendors.css"));

    let reload = function(){
        livereload.reload();
        cb();
    };

    lessStream = gulp.src('src/client/**/*.less')
        .pipe(less())
        .pipe(concat('style.css'));

    // It is important to order the concat so our style will be at the moment 
    // and will take into effect.

    merge(cssStream, lessStream)
        .pipe(order([
            "vendors.css",
            "style.css",
        ]))
        .pipe(concat('style.css'))
        .pipe(gulp.dest('dist/css')).on('end', reload);

});

gulp.task('compile-html', (cb) => {
    let reload = function(){
        livereload.reload();
        cb();
    };

    gulp.src('src/client/html/**/*.pug')
        .pipe(pug({
            doctype: 'html',
            pretty: true
        }))
        .pipe(gulp.dest('dist')).on('end', reload);
});

gulp.task('start-server', () => {

    nodemon({
        script: 'server.js',
        ext:    'js html',
        watch: ['server.js'],
        env:  { 'NODE_ENV': 'development' }
    });

    // Start listening with livereload.

    livereload({ start: true });
});

// Open browser, using default browser.

gulp.task('browser', () => {
    return gulp.src(__filename)
    .pipe(open({
        uri: 'http://localhost:5000'
    }));
});


//-----------------------------------------------------------------------------//
// Main tasks
//-----------------------------------------------------------------------------//

gulp.task('asset', [
    'minify-img',
    'copy-webfonts'
]);

// Production build.
// Minify files and move asset files to /dist folder.

gulp.task('production', [
    'minify-js', 
    'minify-css',
    'minify-html',
    'minify-img'
]);

// Default task. Run command: "gulp" to start development environment.

gulp.task('default', [
    'compile-js', 
    'compile-css', 
    'compile-html', 
    'start-server',
    'browser'
]);

//-----------------------------------------------------------------------------//
// Watch changes
//-----------------------------------------------------------------------------//

gulp.watch('src/client/js/**', ['compile-js']);
gulp.watch('src/server/**/*.coffee', ['compile-server']);
gulp.watch('src/css/**',  ['compile-css']);
gulp.watch('src/html/**', ['compile-html']);

//-----------------------------------------------------------------------------//