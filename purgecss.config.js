module.exports = {
  content: ["_site/**/*.html", "_site/**/*.js"],
  css: ["_site/assets/css/*.css"],
  output: "_site/assets/css/",
  skippedContentGlobs: ["_site/assets/**/*.html"],
  // Classes on /repositories/ cards that only render for some repos (a fork
  // count, an archived repo). They are absent from the HTML at build time, so
  // PurgeCSS would drop their styles and they would render unstyled later.
  safelist: ["fa-code-fork", "repo-card-badge"],
};
