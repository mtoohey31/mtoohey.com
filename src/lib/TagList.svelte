<script lang="ts">
  export let tags: Array<string>;
  export let caps = true;
  export let brackets = false;
  export let updateTags: ((tag: string) => void) = void(0);
</script>

<span>{caps ? "T" : "t"}ags: </span>
{#if brackets}[{/if}{#if updateTags}{#each tags.slice(0, -1) as tag}
    <div class="text-nord8 hover:underline cursor-pointer inline" on:click={() => updateTags(tag)}>{tag}</div><span>,</span>
  {/each}<div class="text-nord8 hover:underline cursor-pointer inline" on:click={() => updateTags(tags[tags.length - 1])}
    >{tags[tags.length - 1]}</div
  >{:else}{#each tags.slice(0, -1) as tag}
    <a href="/articles?tag={encodeURIComponent(tag)}">{tag}</a><span>,</span>
  {/each}<a href="/articles?tag={encodeURIComponent(tags[tags.length - 1])}"
    >{tags[tags.length - 1]}</a
  >{/if}{#if brackets}]{/if}
