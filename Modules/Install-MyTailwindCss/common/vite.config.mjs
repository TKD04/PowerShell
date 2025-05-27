import tailwindcss from "@tailwindcss/vite";
import { defineConfig } from "vite";

/** @see {@link https://vite.dev/config/} */
const config = defineConfig({
  plugins: [tailwindcss()],
});

export default config;
