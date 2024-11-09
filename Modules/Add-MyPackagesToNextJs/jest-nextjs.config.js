/** @type {import('ts-jest').JestConfigWithTsJest} */
module.exports = {
  coverageProvider: "v8",
  roots: ["<rootDir>"],
  testPathIgnorePatterns: ["<rootDir>[/\\\\](node_modules|.next)[/\\\\]"],
  testEnvironment: "jsdom",
  preset: "ts-jest",
};
