import react from "@vitejs/plugin-react-swc";
import type { UserConfig } from "vite";

export default {
  plugins: [react()],
  resolve: {
    alias: {
      "@": "/src",
    },
  },
} satisfies UserConfig;
