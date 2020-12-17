const concurrently = require('concurrently');

// By default, configure Bridgetown to use port 4001 so Browsersync can use 4000
// See also Browsersync settings in sync.js
const port = 4001

/////////////////
// Concurrently
/////////////////
concurrently([
  { command: "NODE_ENV=development yarn snowpack build --watch", name: "Snowpack", prefixColor: "yellow" },
  { command: "sleep 4; bundle exec bridgetown serve --port " + port, name: "Bridgetown", prefixColor: "green" },
  { command: "sleep 8; yarn sync", name: "Live", prefixColor: "blue" }
], {
  restartTries: 3,
  killOthers: ['failure', 'success'],
}).then(() => { console.log("Done."); console.log('\033[0G'); }, () => { });
