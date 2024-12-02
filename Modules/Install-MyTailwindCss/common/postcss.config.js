module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
    // https://tailwindcss.com/docs/optimizing-for-production
    ...(process.env.NODE_ENV === "production" ? { cssnano: {} } : {}),
  },
};
