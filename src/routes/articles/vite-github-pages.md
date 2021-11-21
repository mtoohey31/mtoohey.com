---
title: Deploying a Vite App to GitHub Pages
description: GitHub pages require relative paths to assets, which Vite doesn't cooperate with by default, but we can fix that!
posted: November 20, 2021
tags: [Vite, GitHub, GitHub Pages]
---

<!-- cspell:ignore Vite -->

## The Starting Point

I'll assume that you already have a Vite application, and that you're just trying to deploy it to GitHub pages. I'll also assume that you have the project repository set up on GitHub.

## Setup

The only additional dependency we'll need is [`gh-pages`](https://www.npmjs.com/package/gh-pages), you can install it with one of:

```bash
npm install --save-dev gh-pages
yarn add -D gh-pages # if you're using yarn
pnpm add -D gh-pages # if you're using pnpm
```

Create the following file:

```js
// scripts/gh-pages.js
import { publish } from "gh-pages";

publish(
  "dist",
  {
    branch: "gh-pages",
    dotfiles: true,
    repo: "<your github repository url>",
    user: {
      name: "<your name for git>",
      email: "<your email for git>",
    },
  },
  () => {
    console.log("Deploy Complete!");
  }
);
```

This script will use `gh-pages` to deploy the application to the `gh-pages` branch, so that we don't mess up the main branch with the bundled files. Then, add the following `deploy` script to your `package.json`, and modify the `build` script:

```json
{
  "scripts": {
    "build": "vite build --base='./'",
    "deploy": "\"$npm_execpath\" run build && \"$npm_node_execpath\" ./scripts/gh-pages.js"
  }
}
```

The `--base='./'` argument ensures that Vite will prefix asset links with `"./"` instead of `"/"`, which is required since GitHub pages will deploy your site to a sub-route of `https://<github username>.github.io`. Finally, to deploy the site, run:

```bash
npm run deploy # or yarn or pnpm
```

Your site should now be available at `https://<github username>.github.io/<repo name>/`. If it isn't, refer to the following section.

## Troubleshooting Steps

1. Ensure the build is actually being created by checking for the `gh-pages` branch on the GitHub repository.
2. Make sure the build actually works: fetch and check out the `gh-pages` branch then try serving it with something like `python2 -m SimpleHTTPServer 8000`.
3. Check your repository's pages settings under Settings > Pages, and ensure that the branch is `gh-pages`, and the directory is `/ (root)`. If things are working correctly, the page should display: "Your site is published at https://<github username>.github.io/<repo name>/".

## Sources

Much of the boilerplate for this article came from [https://blog.stranianelli.com/svelte-et-github-english/](https://blog.stranianelli.com/svelte-et-github-english/), so check it out if you're running into issues. Note that it was not written with Vite in mind though, so the `--base'./'` fix is not mentioned.
