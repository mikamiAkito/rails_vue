import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import vue from '@vitejs/plugin-vue'
import tailwindcss from 'tailwindcss' //import * asの形に修正するとpostcssが認証されなくなる
import autoprefixer from 'autoprefixer' //import * asの形に修正するとpostcssが認証されなくなる

export default defineConfig({
  plugins: [
    RubyPlugin(),
    vue(),
  ],
  css: {
    postcss: {
      plugins: [
        tailwindcss,
        autoprefixer,
      ],
    },
  },
})