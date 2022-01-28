<script context="module" lang="ts">
  import { page } from "$app/stores";
  export async function load({ fetch }) {
    const res = await fetch("/article-index.json");
    return { props: { articles: await res.json() } };
  }
</script>

<script lang="ts">
  import TagList from "$lib/TagList.svelte";
  function getInfoString(article: { posted?: string; modified?: string }) {
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
  function updateTags(tag?: string): void {
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
          (article: { tags?: string[] }) =>
            article.tags &&
            tags.some((tag: string) => article.tags.indexOf(tag) !== -1)
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
      Filtering By <TagList {tags} {updateTags} />
      <div
        class="cursor-pointer float-right hover:underline"
        on:click={() => {
          updateTags();
        }}
      >
        Clear
      </div>
    </blockquote>
  {/if}
  {#if filteredArticles.length}
    {#each filteredArticles.sort((a, b) => {
      return +new Date(b.posted) - +new Date(a.posted);
    }) as article}
      <hr />
      {#if article.image}
        <div
          class="flex justify-between h-full"
        >
          <div class="flex-shrink">
            <h2>
              <a sveltekit:prefetch href="/articles/{article.route}"
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
            class="flex-shrink self-center overflow-scroll w-full inline-flex"
          />
        </div>
      {:else}
        <h2><a href="/articles/{article.route}">{article.title}</a></h2>
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
