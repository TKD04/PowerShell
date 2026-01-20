import react from "@vitejs/plugin-react";
import type { UserConfig } from "vite";

export default {
  plugins: [
    react({
      babel: {
        plugins: [["babel-plugin-react-compiler"]],
      },
    }),
  ],
  resolve: {
    alias: {
      "@": "/src",
    },
  },
} satisfies UserConfig;
