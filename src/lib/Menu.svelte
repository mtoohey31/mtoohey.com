<script>
  const routes = ["/", "/Articles"];
  import RouteBreadcrumb from "$lib/RouteBreadcrumb.svelte";
</script>

<span class="menu"
  >{#each routes as route}
    <div>
      <RouteBreadcrumb path={route} />
    </div>
  {/each}</span
>

<style>
  .menu {
    margin-left: 0.5rem;
    position: absolute;
    background-color: var(--primary-color);
  }
</style>
