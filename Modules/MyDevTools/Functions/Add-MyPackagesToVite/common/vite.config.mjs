import path from "node:path";

import { defineConfig } from "vite";

const config = defineConfig({
  resolve: {
    alias: {
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-member-access
      "@": path.resolve(import.meta.dirname, "./src"),
    },
  },
});

export default config;
