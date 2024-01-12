---
title: Fixing Broken SRI Checks with Cloudflare
description: Instructions for fixing subresource integrity checks when using Cloudflare.
published: 2023-12-15
modified: 2024-01-05
tags: [SRI, Cloudflare, Hugo]
---

<!-- cspell:ignore subresource -->

## Explanation and Solution

If you're seeing an error similar to the following in Chrome:

```text
Failed to find a valid digest in the 'integrity' attribute for resource '...' with computed ... integrity '...'. The resource has been blocked.
```

...or this one, in Firefox:

```text
None of the “...” hashes in the integrity attribute match the content of the subresource. The computed hash is “...”.
```

...when trying to load your site through Cloudflare, but you're not getting any errors when running it locally, there's a good chance it's related to the minification they automatically apply to CSS and/or JS files. Since minification changes the contents of the file to make it smaller if possible, this can break [subresource integrity](https://developer.mozilla.org/en-US/docs/Web/Security/Subresource_Integrity) hash checks, causing the resource to be rejected.

You can fix this by disabling the "Auto Minify" feature for CSS and/or JS in the Cloudflare dashboard. The page in Cloudflare's docs [here](https://developers.cloudflare.com/speed/optimization/content/auto-minify/) describes how to configure the feature. After disabling it, don't forget to purge your cache, as that page recommends.

## Terraform Configuration

If you're configuring Cloudflare with Terraform, the following snippet will allow you to declaratively disable minification:

```hcl
resource "cloudflare_zone_settings_override" "<name>" {
  zone_id = "<zone-id>"
  settings {
    minify {
      css  = "off"
      html = "on"
      js   = "off"
    }
  }
}
```
