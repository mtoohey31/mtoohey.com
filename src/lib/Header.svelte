<script lang="ts">
  import { page } from "$app/stores";
</script>

<header class="font-mono mx-4 my-2 flex justify-between overflow-x-hidden h-8">
  <a class:text-nord8={$page.path === "/"} class:dark:text-nord10={$page.path === "/"} class="mr-1" sveltekit:prefetch href="/"
    >mtoohey.com</a
  ><span>
    [<a
      class:text-nord8={$page.path === "/articles"}
      class:dark:text-nord10={$page.path === "/articles"}
      sveltekit:prefetch
      href="/articles">articles</a
    >,
    <a
      class:text-nord8={$page.path === "/contact"}
      class:dark:text-nord10={$page.path === "/contact"}
      sveltekit:prefetch
      href="/contact">contact</a
    >,
    <a class:text-nord8={$page.path === "/links"} class:dark:text-nord10={$page.path === "/links"} sveltekit:prefetch href="/links"
      >links</a
    >]
  </span>
  <span class="opacity-0 select-none">mtoohey.com</span>
</header>
