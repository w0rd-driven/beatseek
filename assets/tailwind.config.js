// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin")

module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/*_web.ex",
    "../lib/*_web/**/*.*ex"
  ],
  theme: {
    extend: {
      colors: {
        'primary-dark': 'var(--primary-dark)',
        primary: {
          900: 'var(--primary-900)',
          800: 'var(--primary-800)',
          700: 'var(--primary-700)',
          600: 'var(--primary-600)',
          500: 'var(--primary-500)',
          400: 'var(--primary-400)',
          300: 'var(--primary-300)',
          200: 'var(--primary-200)',
          100: 'var(--primary-100)',
        },
        'secondary-dark': 'var(--secondary-dark)',
        secondary: {
          900: 'var(--secondary-900)',
          800: 'var(--secondary-800)',
          700: 'var(--secondary-700)',
          600: 'var(--secondary-600)',
          500: 'var(--secondary-500)',
          400: 'var(--secondary-400)',
          300: 'var(--secondary-300)',
          200: 'var(--secondary-200)',
          100: 'var(--secondary-100)',
        },
        'neutral-dark': 'var(--neutral-dark)',
        neutral: {
          900: 'var(--neutral-900)',
          800: 'var(--neutral-800)',
          700: 'var(--neutral-700)',
          600: 'var(--neutral-600)',
          500: 'var(--neutral-500)',
          400: 'var(--neutral-400)',
          300: 'var(--neutral-300)',
          200: 'var(--neutral-200)',
          100: 'var(--neutral-100)',
        },
        'supporting-teal-dark': 'var(--supporting-teal-dark)',
        'supporting-teal': {
          900: 'var(--supporting-teal-900)',
          800: 'var(--supporting-teal-800)',
          700: 'var(--supporting-teal-700)',
          600: 'var(--supporting-teal-600)',
          500: 'var(--supporting-teal-500)',
          400: 'var(--supporting-teal-400)',
          300: 'var(--supporting-teal-300)',
          200: 'var(--supporting-teal-200)',
          100: 'var(--supporting-teal-100)',
        },
        'supporting-yellow-dark': 'var(--supporting-yellow-dark)',
        'supporting-yellow': {
          900: 'var(--supporting-yellow-900)',
          800: 'var(--supporting-yellow-800)',
          700: 'var(--supporting-yellow-700)',
          600: 'var(--supporting-yellow-600)',
          500: 'var(--supporting-yellow-500)',
          400: 'var(--supporting-yellow-400)',
          300: 'var(--supporting-yellow-300)',
          200: 'var(--supporting-yellow-200)',
          100: 'var(--supporting-yellow-100)',
        },
      },
      fontFamily: {
        display: ['Karla', 'Calibri', 'Geneva', 'system-ui', 'sans‑serif'],
        body: ['Montserrat', 'Verdana', 'system-ui', 'sans-serif'],
        logo: ['Audiowide', 'system-ui', 'cursive'],
      },
      screens: {
        // '2xl': '1440px',
        'print': { 'raw': 'print' },
      },
      spacing: {
        '72': '18rem',
        '84': '21rem',
        '96': '24rem',
        '128': '32rem',
      },
    }
  },
  plugins: [
    require("@tailwindcss/forms"),
    plugin(({addVariant}) => addVariant("phx-no-feedback", [".phx-no-feedback&", ".phx-no-feedback &"])),
    plugin(({addVariant}) => addVariant("phx-click-loading", [".phx-click-loading&", ".phx-click-loading &"])),
    plugin(({addVariant}) => addVariant("phx-submit-loading", [".phx-submit-loading&", ".phx-submit-loading &"])),
    plugin(({addVariant}) => addVariant("phx-change-loading", [".phx-change-loading&", ".phx-change-loading &"]))
  ]
}
