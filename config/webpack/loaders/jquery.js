module.exports = {
  module: {
    rules: [
      {
        test: require.resolve('jquery'),
        use: [
          {
            loader: require.resolve('expose-loader'),
            options: {
              exposes: ['$', 'jQuery', 'jquery']
            }
          }
        ]
      }
    ]
  }
}
