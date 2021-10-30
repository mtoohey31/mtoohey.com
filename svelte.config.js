import { mdsvex } from "mdsvex";
import mdsvexConfig from "./mdsvex.config.cjs";
import preprocess from "svelte-preprocess";
// import staticAdapter from "@sveltejs/adapter-static";
import cloudflareWorkersAdapter from "@sveltejs/adapter-cloudflare-workers";
// import nodeAdapter from "@sveltejs/adapter-node";

/** @type {import('@sveltejs/kit').Config} */
// module.exports = {
//   extensions: [".svelte", ...mdsvexConfig.extensions],
//   // Consult https://github.com/sveltejs/svelte-preprocess
//   // for more information about preprocessors
//   preprocess: [mdsvex(mdsvexConfig), preprocess()],

//   kit: {
//     // hydrate the <div id="svelte"> element in src/app.html
//     target: "#svelte",
//     // adapter: staticAdapter(),
//     adapter: cloudflareWorkersAdapter(),
//     // adapter: nodeAdapter(),
//   },
// };

/** @type {import('@sveltejs/kit').Config} */
const config = {
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

export default config;
