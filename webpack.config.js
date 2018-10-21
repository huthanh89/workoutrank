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
