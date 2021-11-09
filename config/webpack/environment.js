const { environment } = require('@rails/webpacker')
const erb = require('./loaders/erb')

const sassLoader = environment.loaders.get('sass')
sassLoader.use.splice(-1, 0, {
  loader: 'resolve-url-loader'
})
environment.loaders.prepend('erb', erb)

const webpack = require('webpack')
environment.plugins.append('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    'window.jQuery': 'jquery'
  })
)

environment.splitChunks()
module.exports = environment
