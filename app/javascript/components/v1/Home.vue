<script setup lang="ts">
import { ref, onMounted, Ref } from 'vue';

const topButtonOpacity: Ref<boolean> = ref(false);

const topScrollButton = (): void => {
  console.log("トップへ");
  window.scroll({top: 0, behavior: "smooth"});
};
</script>

<template>
  <div class="text-green-700 absolute top-32">
    こちらはホームです
  </div>
  <div id="top_button" class="fixed -bottom-14 right-3 duration-700 opacity-0 hover:animate-pulse animate-duration-1000 z-10"
  :class="{
    'opacity-100':topButtonOpacity,
    '-translate-y-16':topButtonOpacity
  }" @click="topScrollButton">
    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"
    class="stroke-orange-500 size-12 md:size-16">
      <path stroke-linecap="round" stroke-linejoin="round" d="m15 11.25-3-3m0 0-3 3m3-3v7.5M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z" />
    </svg>
  </div>
</template>

<style>
</style>