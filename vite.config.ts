import { defineConfig } from "vite"
import ViteRails from "vite-plugin-rails"

export default defineConfig(({ mode }) => ({
  plugins: [ViteRails()],
  build: {
    sourcemap: true,
  },
}))
