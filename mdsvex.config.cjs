module.exports = {
  layout: {
    article: "./src/lib/layouts/article.svelte",
    page: "./src/lib/layouts/page.svelte",
    _: "./src/lib/layouts/article.svelte",
  },
  extensions: [".svx", ".md"],
  smartypants: {
    dashes: "oldschool",
  },
  remarkPlugins: [
    [
      require("remark-github"),
      {
        // Use your own repository
        repository: "https://github.com/svelte-add/mdsvex.git",
      },
    ],
    require("remark-abbr"),
    require("remark-gemoji"),
  ],
  rehypePlugins: [
    require("rehype-slug"),
    [
      require("rehype-autolink-headings"),
      {
        behavior: "wrap",
      },
    ],
  ],
};
