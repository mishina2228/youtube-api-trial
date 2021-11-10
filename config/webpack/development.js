process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const { merge } = require('@rails/webpacker')
const webpackConfig = require('./base')
const webpackBundlerAnalyzer = require('./loaders/webpack_bundle_analyzer')

module.exports = merge(webpackConfig, webpackBundlerAnalyzer)
