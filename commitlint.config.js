export default {
  extends: ["@andrewmcodes"],
  ignores: [(message) => message.startsWith("Merge ")],
};
