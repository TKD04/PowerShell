import path from "node:path";

import react from "@vitejs/plugin-react-swc";
import { defineConfig } from "vite";

const config = defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-member-access
      "@": path.resolve(import.meta.dirname, "./src"),
    },
  },
});

export default config;
