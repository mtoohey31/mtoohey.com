<script lang="ts">
  import { page } from "$app/stores";
  export const prerender = true;
  let title =
    $page.path !== "/"
      ? decodeURI($page.path).replace(/(.*[^\\])?\//, "")
      : "Matthew Toohey";
</script>

<svelte:head>
  <title>{title}</title>
</svelte:head>

<slot />
