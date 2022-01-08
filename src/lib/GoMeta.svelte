<script lang="ts">
  import { page } from "$app/stores";

  export let redirect: string;
  export const host = $page.host;
  const basename = $page.path.replace(/^\//, "").split("/")[0];
</script>

<svelte:head>
  {#if $page.query.get("go-get") === "1"}
    <meta
      name="go-import"
      content={`${host}/${basename} git ${redirect}/${basename}.git`}
    />
  {/if}
</svelte:head>
