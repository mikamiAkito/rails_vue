<script setup lang="ts">
import { onMounted, ref } from 'vue';

const props = defineProps({
  bookMarkItems: Array
});

onMounted(() => {
});
</script>

<template>
  <div>
    <!-- <HeaderPage/> -->
      <div>
        <div class="rounded overflow-hidden shadow-lg border border-blue-400 dark:border-slate-700">
            <a href="#"></a>
            <!-- 店名・住所 -->
            <div class="px-6 py-4">
              <Link
              class="font-semibold text-lg inline-block hover:text-indigo-600 dark:text-white transition duration-500 ease-in-out">
              </Link>
              <p class="text-gray-500 dark:text-white opacity-70 text-sm">
              </p>
            </div>
            <!-- 営業日時 -->
            <div class="px-6 py-4 flex flex-row justify-between">
              <span href="#" class="py-1 text-sm font-regular text-gray-900 mr-1 flex flex-row items-center">
                <svg height="13px" width="13px" version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg"
                xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 512 512"
                style="enable-background:new 0 0 512 512;" xml:space="preserve">
                  <g>
                    <g>
                      <path d="M256,0C114.837,0,0,114.837,0,256s114.837,256,256,256s256-114.837,256-256S397.163,0,256,0z M277.333,256
                      c0,11.797-9.536,21.333-21.333,21.333h-85.333c-11.797,0-21.333-9.536-21.333-21.333s9.536-21.333,21.333-21.333h64v-128
                      c0-11.797,9.536-21.333,21.333-21.333s21.333,9.536,21.333,21.333V256z"></path>
                    </g>
                  </g>
                </svg>
                <span class="ml-1">お気に入り登録一覧ページです</span>
              </span>
            </div>
          </div>
      </div>
    <FooterPage/>
  </div>
</template>

<style>
</style>