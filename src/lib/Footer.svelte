<script lang="ts">
  import { mdiGithub, mdiImageFilterHdr } from "@mdi/js";
</script>

<footer>
  <a href="https://github.com/mtoohey31/mtoohey.com">
    <span class="icon">
      <svg viewBox="0 0 24 24" aria-hidden="true">
        <path fill="var(--theme-text)" d={mdiGithub} />
      </svg></span
    >
    source</a
  >
  <a href="https://www.nordtheme.com/">
    <span class="icon">
      <svg viewBox="0 0 24 24" aria-hidden="true">
        <path fill="var(--theme-text)" d={mdiImageFilterHdr} />
      </svg></span
    >
    theme</a
  >
</footer>

<style>
  footer {
    text-align: center;
    font-family: var(--font-mono);
    margin: 1rem;
  }
  .icon svg {
    height: 1em;
    width: 1em;
    top: 0.125em;
    position: relative;
  }
</style>
