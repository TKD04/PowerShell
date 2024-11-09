/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./src/**/*.{pug,ts,tsx}"],
  plugins: [require("@tailwindcss/typography"), require("daisyui")],
};
