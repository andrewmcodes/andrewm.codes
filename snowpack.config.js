module.exports = {
  mount: {
    frontend: '/_bridgetown',
    public: '/'
  },
  plugins: [
    [
      '@snowpack/plugin-build-script',
      { cmd: 'postcss', input: ['.css'], output: ['.css'] }
    ],
    ['@snowpack/plugin-optimize'],
    [
      'snowpack-plugin-imagemin',
      {
        include: ['**/*.jpg', '**/*.png'],
        plugins: [
          require('imagemin-mozjpeg')({ quality: 90, progressive: true }),
          require('imagemin-optipng')({ optimizationLevel: 7 })
        ]
      }
    ]
  ],
  installOptions: {},
  devOptions: {
    out: ""
  },
  buildOptions: {
    out: "build",
    sourceMaps: true
  }
}
