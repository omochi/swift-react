import { resolve } from 'path';
import { defineConfig } from 'vite';

export default defineConfig({
  build: {
    rollupOptions: {
      input: {
        QSComponents: resolve(__dirname, "pages/QSComponents.html"),
        QSMarkup: resolve(__dirname, "pages/QSMarkup.html"),
        QSDisplayingData: resolve(__dirname, "pages/QSDisplayingData.html"),
        QSConditional: resolve(__dirname, "pages/QSConditional.html"),
        QSLists: resolve(__dirname, "pages/QSLists.html"),
        QSEvents: resolve(__dirname, "pages/QSEvents.html"),
        QSUpdating: resolve(__dirname, "pages/QSUpdating.html"),
      },
    },
  }
});