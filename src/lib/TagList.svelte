<script lang="ts">
  export let tags: Array<String>;
  export let caps = true;
</script>

<span>{caps ? "T" : "t"}ags: </span>
{#each tags.slice(0, -1) as tag}
  <a rel="external" href="/articles?tag={tag}">{tag}</a><span>,</span>
{/each}<a rel="external" href="/articles?tag={tags[tags.length - 1]}"
  >{tags[tags.length - 1]}</a
>
