// /** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./public/*.html",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/assets/**/*.css",
    "./app/assets/**/*.scss",
    "./app/views/**/*",
    "./node_modules/flowbite/**/*.js",
  ],
  theme: {
    extend: {
      fontFamily: {
        body: ['"Good Sans", sans-serif'],
        sans: ['"Good Sans", sans-serif'],
        serif: ["Queen", "serif"],
      },
    },
  },
  plugins: [require("flowbite/plugin")],
};
