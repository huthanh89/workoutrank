#-------------------------------------------------------------------------------
# Imports
#-------------------------------------------------------------------------------

path    = require 'path'
webpack = require 'webpack'

#-------------------------------------------------------------------------------
# Webpack Options
#-------------------------------------------------------------------------------

webpackPlugins = [
  new webpack.ProvidePlugin({
    $:      'jquery'
    jQuery: 'jquery'
  })
]

Options =

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
      mmenu:                      'jquery.mmenu.all.js'
      touchspin:                  'jquery.bootstrap-touchspin.js'
      multiselect:                'jquery.bootstrap-multiselect.js'
      datepicker:                 'jquery.bootstrap-datepicker.js'
      JQPlugin:                   'jquery.plugin.js'
      'bootstrap.datetimepicker': 'bootstrap.datetimepicker.js'
      'bootstrap.paginate':       'bootstrap.paginate.js'
      toastr:                     'toastr.js'
      fullcalendar:               'fullcalendar.js'
      sweetalert:                 'sweetalert.js'
      gauge:                      'gauge.js'
      waypoint:                   'jquery.waypoints.js'
      infinite:                   'jquery.infinite.js'

    # Resolve files ending with the following extension.

    extensions: [
      '.coffee'
      '.js'
    ]

  plugins: webpackPlugins

#-------------------------------------------------------------------------------
# Exports
#-------------------------------------------------------------------------------

module.exports = Options

#-------------------------------------------------------------------------------