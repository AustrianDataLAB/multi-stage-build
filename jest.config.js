module.exports = {
  // other configuration...
  reporters: [
    "default",
    ["jest-junit", { outputDirectory: "./test-results/junit" }]
  ]
};