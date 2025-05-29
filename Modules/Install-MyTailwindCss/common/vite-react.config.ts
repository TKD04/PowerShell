import tailwindcss from "@tailwindcss/vite";
import react from "@vitejs/plugin-react-swc";
import { defineConfig } from "vite";

/** @see {@link https://vite.dev/config/} */
const config = defineConfig({
  plugins: [react(), tailwindcss()],
});

export default config;
