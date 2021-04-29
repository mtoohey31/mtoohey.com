<script context="module" lang="ts">
  import { page } from "$app/stores";
  export async function load({ fetch }) {
    const res = await fetch("/articles.json");
    return { props: { articles: await res.json() } };
  }
</script>

<script lang="ts">
  import TagList from "$lib/TagList.svelte";
  function getInfoString(article) {
    let arr = [];
    if (article.posted) {
      arr.push(`Posted: ${article.posted}`);
    }
    if (article.modified) {
      arr.push(`Modified: ${article.modified}`);
    }
    return arr.length === 0 ? "" : arr.join("; ") + "; ";
  }
  let tags = $page.query.getAll("tag");
  function updateTags(tag?: String): void {
    if (tag) {
      tags = [tag];
      let searchParams = new URLSearchParams();
      searchParams.set("tag", tag);
      window.history.pushState({}, "articles", "?" + searchParams.toString());
    } else {
      tags = [];
      window.history.pushState({}, "articles", "/articles");
    }
    filteredArticles = getFilteredArticles();
  }
  function getFilteredArticles() {
    return tags.length
      ? $$props.articles.filter(
          (article) =>
            article.tags && tags.some((tag) => article.tags.indexOf(tag) !== -1)
        )
      : $$props.articles;
  }
  let filteredArticles = getFilteredArticles();
</script>

<svelte:head>
  <title>articles</title>
</svelte:head>

<h1>articles</h1>
{#key tags}
  {#if tags.length !== 0}
    <blockquote>
      <TagList {tags} {updateTags} />
      <a
        style="float: right;"
        on:click={() => {
          updateTags();
        }}>Clear</a
      >
    </blockquote>
  {/if}
  {#if filteredArticles.length}
    {#each filteredArticles as article}
      <hr />
      {#if article.image}
        <div
          style="display: flex; justify-content: space-between; height: 100%;"
        >
          <div style="flex-shrink: 1.5;">
            <h2>
              <a sveltekit:prefetch href="/articles/{article.title}"
                >{article.title}</a
              >
            </h2>
            {#if article.posted || article.modified || article.tags}
              <blockquote>
                {getInfoString(article)}<TagList
                  tags={article.tags}
                  {updateTags}
                />
              </blockquote>
            {/if}
            {article.description}
          </div>
          <img
            src={article.image}
            style="flex-shrink: 1; align-self: center; overflow: scroll; width: 100%; display: inline-flex;"
          />
        </div>
      {:else}
        <h2><a href="/articles/{article.title}">{article.title}</a></h2>
        {#if article.posted || article.modified || article.tags}
          <blockquote>
            {getInfoString(article)}<TagList tags={article.tags} {updateTags} />
          </blockquote>
        {/if}
        {#if article.description}
          {article.description}
        {/if}
      {/if}
    {/each}
  {:else if tags.length}
    No articles were found with the specified tags, return to <a
      rel="external"
      href="/articles">all articles</a
    >?
  {:else}
    No articles have been posted yet, please check back later!
  {/if}
{/key}
