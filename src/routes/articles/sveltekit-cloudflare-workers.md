---
title: Deploying a SvelteKit Site to a Cloudflare Worker
description: SvelteKit's experimental Cloudflare Workers adapter provides a way to easily deploy a SvelteKit site to Cloudflare workers.
posted: April 29, 2021
tags: [SvelteKit, Cloudflare, Cloudflare Workers]
---

> Heads Up! At the time of writing, SvelteKit is still in beta, and the Cloudflare Workers adapter is also experimental. For updates on the status of SvelteKit, refer to the [GitHub repo](https://github.com/sveltejs/kit/). Information regarding the Cloudflare Workers adapter can currently be found inside that repo [here](https://github.com/sveltejs/kit/tree/master/packages/adapter-cloudflare-workers#adapter-cloudflare-workers).

## What You'll Need

- A SvelteKit site. If you haven't created one yet, but you want to try deploying one to Cloudflare Workers, you can create one using `npm init svelte@next`.
- A Cloudflare account. You can create one for free at <https://www.cloudflare.com/>.
- A domain configured to use Cloudflare's DNS. Cloudflare's help center includes information on [how to set up a domain](https://support.cloudflare.com/hc/en-us/articles/201720164-Creating-a-Cloudflare-account-and-adding-a-website).

## Wrangler Installation

[Wrangler](https://developers.cloudflare.com/workers/cli-wrangler) is Cloudflare's command-line tool for managing worker sites. If you have npm installed with the correct permissions, you can install Wrangler with:

```bash
npm i @cloudflare/wrangler -g
```

If you encounter errors using this approach (which I did, since I installed npm via my package manager instead of with a version manager), you can also install it using cargo with:

```bash
cargo install wrangler
```

If neither of these approaches works for you, you can also install Wrangler manually, instructions for that process can be found [here](https://developers.cloudflare.com/workers/cli-wrangler/install-update#manual-install).

## Switching Adapters

To deploy our website to a Cloudflare Worker, we need to switch the _adapter_ that `npm run build` will use. As the [SvelteKit docs](https://kit.svelte.dev/docs#adapters) explain, adapters are plugins that transform a built app and output it in a format that is optimized for the specific platform. First, we need to install the adapter:

```bash
npm i @sveltejs/adapter-cloudflare-workers@next
```

Be sure that you include the `@next` at the end of the package, otherwise, it won't install the right version. Then we need to modify our Svelte configuration to use it:

```diff
  // svelte.config/cjs

  const preprocess = require("svelte-preprocess");
+ const adapterCloudflareWorkers = require("@sveltejs/adapter-cloudflare-workers");

  module.exports = {
    preprocess: preprocess(),

    kit: {
      target: "#svelte",
+     adapter: adapterCloudflareWorkers(),
    },
  };
```

Note that if you're using additional preprocessors, this file may look slightly different for you. Don't worry if the rest of your configuration doesn't look identical, the important part is that `kit: {adapter: ...}` is configured to use the Cloudflare Worker import.

Now when you run `npm run build`, after the initial app is built, the adapter will also be run. At this point, it will still encounter errors though because we haven't configured Wrangler yet, so that's what we'll do next!

## Configuring Wrangler

If you tried running `npm run build` after the previous step, you should see an error that reads `Missing a wrangler.toml file`. It will also print a sample `wrangler.toml`, we'll need to make a few modifications from this sample though, so I'd suggest starting with the template below.

```toml
name = "<your-workers-name>"
type = "javascript"
account_id = "<your-account-id>"
workers_dev = true
route = "<your-desired-route>"
zone_id = "<your-sites-zone-id>"

[build]
command = "npm run build"
upload = { format = "service-worker" }

[site]
bucket = "./.cloudflare/assets"
entry-point = "./.cloudflare/worker"
```

The `name` field only determines the name of the worker that is created, so there are no specific requirements on what you enter. Both the `account_id` and `zone_id` can be found by logging into [dash.cloudflare.com](https://dash.cloudflare.com/), selecting the site you're deploying to, and scrolling to the bottom of the "Overview" page. Finally, the `route` field will determine which site routes are intercepted by the worker. If you want your site to be served for all routes navigating to your site with no sub-host, enter `domain.com/*`, or if you want it to match all requests, use `*domain.com/*`. For more detailed information about the pattern matching behaviour of route patterns, refer to [Cloudflare's documentation](https://developers.cloudflare.com/workers/platform/routes).

If you're managing your site with version control, don't forget to add the `wrangler.toml` and `.cloudflare` directories to your `.gitignore`, so there's no risk of accidentally leaking your credentials.

Lastly, you need to authenticate Wrangler so it has permission to make changes, which you can do by running:

```bash
wrangler login
```

Be aware that this method will leave your API key in plain text in a file located at `~/.wrangler/config/default.toml`. You can also authenticate Wrangler using one of the other authentication methods listed in [Cloudflare's documentation](https://developers.cloudflare.com/workers/cli-wrangler/authentication).

## Deploying!

Hypothetically, if everything went correctly, you should now be able to deploy your site by running:

```bash
wrangler publish
```

This will build the site, process it with the Cloudflare Workers adapter, upload all static assets, then upload the `javascript` component of the worker and start it. If this process succeeds without errors, your site should be available within a minute or two on the routes you specified!

If you encounter an error at this point that says `wrangler is not installed`, this might be due to incorrect permissions on your npm installation. As a workaround, you can install Wrangler using the [cargo method](#wrangler-installation).

Cloudflare's current requirements allow 100,000 worker requests per day, so this solution should be free for small sites! For more information on Cloudflare Workers sites, check out the [documentation](https://developers.cloudflare.com/workers/platform/sites)!
