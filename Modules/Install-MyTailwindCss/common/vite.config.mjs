import path from "node:path";

import tailwindcss from "@tailwindcss/vite";
import { defineConfig } from "vite";

/** @see {@link https://vite.dev/config/} */
const config = defineConfig({
  plugins: [tailwindcss()],
  resolve: {
    alias: {
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-member-access
      "@": path.resolve(import.meta.dirname, "./src"),
    },
  },
});

export default config;
