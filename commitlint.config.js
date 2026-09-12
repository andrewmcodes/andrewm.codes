export default {
  extends: ["@andrewmcodes"],
  ignores: [
    (message) => message.startsWith("Merge "),
    (message) => message.trim() === "Initial plan",
  ],
};
