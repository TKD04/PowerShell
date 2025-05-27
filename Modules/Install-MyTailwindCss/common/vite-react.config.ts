import tailwindcss from "@tailwindcss/vite";
import react from "@vitejs/plugin-react";
import { defineConfig } from "vite";

/** @see {@link https://vite.dev/config/} */
export default defineConfig({
  plugins: [react(), tailwindcss()],
});
