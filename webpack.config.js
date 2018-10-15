//-----------------------------------------------------------------------------//
// Import
//-----------------------------------------------------------------------------//

const webpack = require('webpack');

//-----------------------------------------------------------------------------//

module.exports = {

//  entry: './src/client/js/index.coffee',

  performance: { 
    hints: false 
  },

  output: {
    filename: 'bundle.js'
  },

  // Configure how modules are resolved.

  resolve: {

    // Specify location for all the places webpack should look for modules.

    modules: [
      'node_modules', 
      './src/client/js',
      './src/client/vendor/js'
    ],

    alias: {
      'backbone.paginator':       'backbone.paginator.js',
      'backbone.modal':           'backbone.modal-bundled.js',
      'backbone.validation':      'backbone.validation.js',
      'socket.io':                'socket.io.js',
      highstock:                  'highstock.js',
      bootstrap:                  'bootstrap.js',
      'bootstrap.validator':      'bootstrap.validator.js',
      'jquery.ui':                'jquery-ui.js',
      mmenu:                      'jquery.mmenu.all.js',
      touchspin:                  'jquery.bootstrap-touchspin.js',
      multiselect:                'jquery.bootstrap-multiselect.js',
      datepicker:                 'jquery.bootstrap-datepicker.js',
      JQPlugin:                   'jquery.plugin.js',
      'bootstrap.datetimepicker': 'bootstrap.datetimepicker.js',
      'bootstrap.paginate':       'bootstrap.paginate.js',
      toastr:                     'toastr.js',
      fullcalendar:               'fullcalendar.js',
      sweetalert:                 'sweetalert.js',
      gauge:                      'gauge.js',
      waypoint:                   'jquery.waypoints.js',
      infinite:                   'jquery.infinite.js'
    },

    // Import the following, using only the file name without its extension.

    extensions: ['.js', '.coffee']

  },

  // Configure webpack modules to be able to read pug, babel, css etc,
  // By providing the proper module loader.

  module: {
    rules: [
      {
        test: /.coffee?$/,
        loader: 'coffee-loader'
      },
      {
        // When encountering .css files, use css-loader to interpret the file,
        // and style-loader to place the css into the <style> tag.

        test: /.css?$/,
        use: [
          { loader: "style-loader" },
          { loader: "css-loader" }
        ]
      },
      {
        test: /.pug?$/,
        loader: 'pug-loader',
      },
      {
        test: /.jsx?$/,
        loader: 'babel-loader',
        exclude: /node_modules/,
        query: {
          presets: ['@babel/react']
        }
      }
    ]
  },
  
  plugins: [
    new webpack.AutomaticPrefetchPlugin(),
    new webpack.IgnorePlugin(/^\.\/locale$/, /moment$/)
  ]
  
};

//-----------------------------------------------------------------------------//
