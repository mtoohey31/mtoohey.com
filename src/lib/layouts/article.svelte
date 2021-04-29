<script lang="ts">
  import { page } from "$app/stores";
  import TagList from "$lib/TagList.svelte";
  let blacklisted_props = ["description", "image", "layout", "tags"];
  let public_props = Object.keys($$props).filter(
    (prop) =>
      !/^(\$\$)|(_)/.test(prop) && blacklisted_props.indexOf(prop) === -1
  );
  let title =
    $page.path !== "/"
      ? decodeURI($page.path).replace(/(.*[^\\])?\//, "")
      : "Matthew Toohey";
</script>

<svelte:head>
  <title>{title}</title>
  {#if $$props.author}
    <meta name="author" content={$$props.author} />
  {:else}
    <meta name="author" content="Matthew Toohey" />
  {/if}
  {#if $$props.tags}
    <meta name="keywords" content={$$props.tags.join(", ")} />
  {/if}
  {#if $$props.description}
    <meta name="description" content={$$props.description} />
  {/if}
</svelte:head>

<h1>{title}</h1>

{#if public_props.length || $$props.tags}
  <pre
    class="language-yaml">
{#each public_props as prop}
<span class="token key">{prop}</span><span class="token punctuation">:</span> <span class="token {typeof $$props[prop] === 'object'? typeof $$props[prop][0] : typeof $$props[prop]}">{typeof $$props[prop] === 'object'? $$props[prop].join(', ') : $$props[prop]}</span><br/>{/each}{#if $$props.tags}<TagList tags={$$props.tags} caps={false}/>{/if}
</pre>
{/if}

<article>
  <slot />
</article>
