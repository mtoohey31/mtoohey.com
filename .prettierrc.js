module.exports = {
  overrides: [{ files: ["*.html"], options: { parser: "go-template" } }],
  plugins: [require("prettier-plugin-go-template")],
};
