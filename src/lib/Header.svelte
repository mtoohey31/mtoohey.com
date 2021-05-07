<script lang="ts">
  import { page } from "$app/stores";
</script>

<header>
  <a class:active={$page.path === "/"} class="home" sveltekit:prefetch href="/"
    >mtoohey.com</a
  ><span>
    [<a
      class:active={$page.path === "/articles"}
      sveltekit:prefetch
      href="/articles">articles</a
    >,
    <a
      class:active={$page.path === "/contact"}
      sveltekit:prefetch
      href="/contact">contact</a
    >,
    <a class:active={$page.path === "/links"} sveltekit:prefetch href="/links"
      >links</a
    >]
  </span>
  <span class="spacer">mtoohey.com</span>
</header>

<style>
  header {
    font-family: var(--font-mono);
    margin: 1rem;
    display: flex;
    justify-content: space-between;
    overflow-x: hidden;
  }
  span {
    padding-left: 1rem;
    font: var(--font-mono);
    white-space: nowrap;
  }
  .spacer {
    color: transparent;
    user-select: none;
  }
</style>
