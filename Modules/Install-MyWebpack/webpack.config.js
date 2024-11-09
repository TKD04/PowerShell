const path = require("path");
const TerserPlugin = require("terser-webpack-plugin");
const PugPlugin = require("pug-plugin");
const CssMinimizerPlugin = require("css-minimizer-webpack-plugin");
const ImageMinimizerPlugin = require("image-minimizer-webpack-plugin");

const srcDir = path.resolve(__dirname, "src");

module.exports = {
  entry: {
    index: path.resolve(__dirname, "src/pug/index.pug"),
  },
  output: {
    clean: true,
  },
  module: {
    rules: [
      {
        include: srcDir,
        test: /\.pug$/i,
        use: PugPlugin.loader,
      },
      {
        include: srcDir,
        test: /\.s[ac]ss$/i,
        use: [
          {
            loader: "css-loader",
            options: {
              url: false,
              sourceMap: true,
              importLoaders: 2,
            },
          },
          {
            loader: "postcss-loader",
            options: {
              postcssOptions: {
                plugins: [["tailwindcss"], ["autoprefixer", { grid: true }]],
              },
            },
          },
          {
            loader: "sass-loader",
            options: {
              sourceMap: true,
            },
          },
        ],
      },
      {
        include: srcDir,
        test: /\.tsx?$/i,
        use: "ts-loader",
        exclude: /[\\/]node_modules[\\/]/,
      },
      {
        include: srcDir,
        test: /\.(jpe?g|png|gif|svg)$/i,
        type: "asset/resource",
      },
    ],
  },
  plugins: [
    new PugPlugin({
      css: {
        filename: "./css/[name].[contenthash:8].css",
      },
      js: {
        filename: "./js/[name].[contenthash:8].js",
      },
    }),
  ],
  optimization: {
    minimizer: [
      new CssMinimizerPlugin(),
      new TerserPlugin(),
      new ImageMinimizerPlugin({
        minimizer: {
          implementation: ImageMinimizerPlugin.imageminMinify,
          options: {
            plugins: [
              "imagemin-mozjpeg",
              "imagemin-pngquant",
              "imagemin-gifsicle",
              "imagemin-svgo",
            ],
          },
        },
      }),
    ],
    runtimeChunk: "single",
    splitChunks: {
      name: "vendor",
      chunks: "all",
    },
    usedExports: true,
  },
  resolve: {
    extensions: [".tsx", ".ts", ".js"],
  },
  devServer: {
    port: 3000,
    static: path.resolve(__dirname, "dist"),
    watchFiles: ["./src/**/*.*"],
    hot: true,
  },
};
