const { mdsvex } = require("mdsvex");
const mdsvexConfig = require("./mdsvex.config.cjs");
const preprocess = require("svelte-preprocess");
// const staticAdapter = require("@sveltejs/adapter-static");
const cloudflareWorkersAdapter = require("@sveltejs/adapter-cloudflare-workers");
// const nodeAdapter = require("@sveltejs/adapter-node");

/** @type {import('@sveltejs/kit').Config} */
module.exports = {
  extensions: [".svelte", ...mdsvexConfig.extensions],
  // Consult https://github.com/sveltejs/svelte-preprocess
  // for more information about preprocessors
  preprocess: [mdsvex(mdsvexConfig), preprocess()],

  kit: {
    // hydrate the <div id="svelte"> element in src/app.html
    target: "#svelte",
    // adapter: staticAdapter(),
    adapter: cloudflareWorkersAdapter(),
    // adapter: nodeAdapter(),
  },
};
