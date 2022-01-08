<script lang="ts">
  import "../app.css";
  import GoMeta from "$lib/GoMeta.svelte";
  import Header from "$lib/Header.svelte";
  import Footer from "$lib/Footer.svelte";
</script>

<GoMeta redirect="https://github.com/mtoohey31" />

<Header />

<main>
  <slot />
</main>

<Footer />

<style>
  main {
    padding: 1rem;
    width: clamp(45ch, calc(100vw - 4rem), 100ch);
    background-color: var(--theme-background-content);
    margin: 0 auto;
    border-radius: 1rem;
  }
</style>
