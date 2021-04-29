<script lang="ts">
  export let tags: Array<String>;
  export let caps = true;
  export let updateTags: (tag: String) => void;
</script>

<span>{caps ? "T" : "t"}ags: </span>
{#if updateTags}{#each tags.slice(0, -1) as tag}
    <a on:click={() => updateTags(tag)}>{tag}</a><span>,</span>
  {/each}<a on:click={() => updateTags(tags[tags.length - 1])}
    >{tags[tags.length - 1]}</a
  >{:else}{#each tags.slice(0, -1) as tag}
    <a href="/articles?tag={encodeURIComponent(tag)}">{tag}</a><span>,</span>
  {/each}<a on:click={() => updateTags(tags[tags.length - 1])}
    >{tags[tags.length - 1]}</a
  >{/if}
