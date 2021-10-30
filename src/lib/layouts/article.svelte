<script lang="ts">
  import TagList from "$lib/TagList.svelte";
  let blacklisted_props = [
    "description",
    "image",
    "layout",
    "route",
    "tags",
    "author",
    "title",
  ];
  let public_props = Object.keys($$props).filter(
    (prop) =>
      !/^(\$\$)|(_)/.test(prop) && blacklisted_props.indexOf(prop) === -1
  );
</script>

<svelte:head>
  <title>{$$props.title}</title>
</svelte:head>

<article itemscope itemtype="http://schema.org/Article">
  <meta itemprop="publisher" content="mtoohey.com" />
  {#if $$props.posted}
    <meta
      itemprop="datePublished"
      content={new Date($$props.posted).toISOString()}
    />
    <meta
      itemprop="dateCreated"
      content={new Date($$props.posted).toISOString()}
    />
    {#if $$props.modified}
      <meta
        itemprop="dateModified"
        content={new Date($$props.modified).toISOString()}
      />
    {:else}
      <meta
        itemprop="dateModified"
        content={new Date($$props.posted).toISOString()}
      />
    {/if}
  {/if}
  <h1 itemprop="name headline">{$$props.title}</h1>

  {#if public_props.length || $$props.tags}
    <pre
      class="language-yaml">
{#each public_props as prop}
<span class="token key">{prop}</span><span class="token punctuation">:</span> <span class="token {typeof $$props[prop] === 'object'? typeof $$props[prop][0] : typeof $$props[prop]}">{typeof $$props[prop] === 'object'? $$props[prop].join(', ') : $$props[prop]}</span><br/>{/each}{#if $$props.tags}<TagList tags={$$props.tags} caps={false} brackets={true}/>{/if}<br />{#if $$props.author}<span class="token key">author</span><span class="token punctuation">:</span> <span itemprop="author" class="token string">{$$props.author}<br/></span>{:else}<span class="token key">author</span><span class="token punctuation">:</span> <a itemprop="author" rel="author" href="/" class="token string">Matthew Toohey</a><br/>{/if}
</pre>
  {/if}

  <div itemprop="articleBody">
    <slot />
  </div>
</article>
