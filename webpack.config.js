const path = require('path')
const webpack = require('webpack')
const { ESBuildMinifyPlugin } = require('esbuild-loader')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')

process.env.NODE_ENV = process.env.NODE_ENV || 'development'
const devMode = process.env.NODE_ENV === 'development'

const config = {
  entry: {
    app: path.resolve(__dirname, 'app/javascript/app/index.js'),
  },
  module: {
    rules: [
      {
        test: /\.(js)$/,
        exclude: /node_modules/,
        loader: 'esbuild-loader',
        options: {
          loader: 'jsx',
          target: 'es2021',
          jsx: 'automatic',
        },
      },
      {
        test: /\.(sa|sc|c)ss$/i,
        use: [
          MiniCssExtractPlugin.loader,
          'css-loader',
          'sass-loader',
        ],
      },
      {
        test: /\.(png|jpe?g|gif|svg|eot|ttf|woff|woff2)$/i,
        type: 'asset',
      },
    ],
  },
  output: {
    filename: '[name].js',
    chunkFilename: '[id].[name].[chunkhash].chunk.js',
    sourceMapFilename: '[file].map',
    path: path.resolve(__dirname, 'app/assets/builds'),
    clean: true,
  },
  plugins: [
    new MiniCssExtractPlugin(),
    new webpack.optimize.MinChunkSizePlugin({ minChunkSize: 10000 }),
  ],
  optimization: {
    minimizer: [
      new ESBuildMinifyPlugin({
        target: ['es2021'],
        css: true,
      }),
    ],
  },
  resolve: {
    modules: [
      path.resolve(__dirname, 'app/javascript/app'),
      path.resolve(__dirname, 'app/assets'),
      'node_modules',
    ],
  },
}

module.exports = () => {
  if (devMode) {
    config.mode = 'development'
    config.devtool = 'eval-source-map'
    config.performance = { hints: 'warning' }
    config.experiments = {}
  } else {
    config.mode = 'production'
    config.devtool = 'source-map'
  }

  return config
}
