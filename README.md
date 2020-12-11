# [andrewm.codes](https://andrewm.codes)

## WARNING: WIP

[![StackShare](http://img.shields.io/badge/tech-stack-0690fa.svg?style=flat)](https://stackshare.io/andrewmcodes/bridgepack)

 "v2:serve": "bundle exec bridgetown server",
    "build:frontend": "snowpack build",
    "build:src": "bundle exec bridgetown build",
    "clean": "bundle exec bridgetown clean",
    "deploy": "yarn clean && BRIDGETOWN_ENV=production yarn build:src && yarn sitemap && NODE_ENV=production yarn build:frontend",
    "dev:frontend": "snowpack build --watch",
    "dev:serve": "bundle exec bridgetown build --watch",
    "dev:src": "sleep 1; bundle exec bridgetown build --watch",
    "prettier:check": "prettier-standard --check",
    "prettier:format": "prettier-standard --format",
    "prettier:lint": "prettier-standard --lint '**/*.{js,css}'",
    "sitemap": "sitemap-static --prefix=https://andrewm.codes output/ > public/sitemap.xml",
    "start": "NODE_ENV=development yarn dev:frontend",
    "sync": "browser-sync start --port 4000 --proxy 'localhost:4001' --serveStatic 'output' --files 'output' --no-open --ws --no-notify"
