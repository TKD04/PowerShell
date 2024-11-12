/* eslint-disable @typescript-eslint/no-var-requires */
const path = require("path");

const srcDir = path.resolve(__dirname, "src");

module.exports = {
  entry: "./src/index.ts",
  output: {
    filename: "[name].js",
    path: path.resolve(__dirname, "dist"),
    clean: true,
  },
  module: {
    rules: [
      {
        include: srcDir,
        test: /\.tsx?$/i,
        use: "ts-loader",
        exclude: /[\\/]node_modules[\\/]/,
      },
    ],
  },
  resolve: {
    extensions: [".tsx", ".ts", ".js"],
  },
};
