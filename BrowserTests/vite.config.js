import { resolve } from 'path';
import { defineConfig } from 'vite';

export default defineConfig({
  build: {
    rollupOptions: {
      input: {
        QSComponents: resolve(__dirname, "pages/QSComponents.html"),
        QSMarkup: resolve(__dirname, "pages/QSMarkup.html"),
      },
    },
  }
});