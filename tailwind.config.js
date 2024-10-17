import defaultTheme from 'tailwindcss/defaultTheme';

/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./app/javascript/**/*.{vue,js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      fontFamily: {
          sans: ['Figtree', ...defaultTheme.fontFamily.sans],
      },
      scale: {
          '450': '4.5',
      },
      keyframes: {
          gnaviAnime: {
              '0%': {
                  opacity: '0'
              },
              '100%': {
                  opacity: '1'
              }
          }
      },
      animation: {
          gnaviAnime: 'gnaviAnime',
      },
      colors: {
          'raba': 'rgba(0,0,0,0.4)'
      },
      height: {
          '13': '3.2rem',
          '18': '4.5rem'
      },
      zIndex: {
          '25': '25',
          '60': '60',
      },
      screens: {
          xs: '240px',
          sm: '480px',
          md: '768px',
          lg: '976px',
          xl: '1440px',
      },
    },
  },

  plugins: [
    require('@tailwindcss/forms'),
    require('flowbite/plugin'),
    require('tailwindcss-animated')
  ],
}