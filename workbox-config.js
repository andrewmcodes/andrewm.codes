module.exports = {
  cacheId: "yoursite",
  globDirectory: "build/",
  globPatterns: ["**/*.{css,js,json}"],
  swDest: "build/sw.js",

  runtimeCaching: [
    {
      urlPattern: /(?:\/)$/,
      handler: "StaleWhileRevalidate",
      options: {
        cacheName: "html",
        expiration: {
          maxAgeSeconds: 60 * 60 * 24 * 7,
        },
      },
    },
    {
      urlPattern: /\.(?:png|jpg|jpeg|gif|webp|svg|ico)$/,
      handler: "CacheFirst",
      options: {
        cacheName: "images",
        expiration: {
          maxAgeSeconds: 30 * 24 * 60 * 60,
          maxEntries: 30,
        },
      },
    },
  ],
}
