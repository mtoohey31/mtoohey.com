<script lang="ts">
  import "../app.css";
  import GoMeta from "$lib/GoMeta.svelte";
  import Header from "$lib/Header.svelte";
  import Footer from "$lib/Footer.svelte";
</script>

<GoMeta redirect="https://github.com/mtoohey31" />

<Header />

<main
  class="bg-nord6 dark:bg-nord1 rounded-2xl sm:mx-4 lg:mx-auto max-w-screen-lg p-4"
>
  <slot />
</main>

<Footer />
