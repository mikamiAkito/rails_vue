<script setup lang="ts">
import { RouterView } from 'vue-router';
import HeaderPage from './v1/HeaderPage.vue';
import axios from 'axios';

//csrf設定
const setupAxios: () => void = () => {
  const token: string | null | undefined = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
  if (token) {
    axios.defaults.headers.common['X-CSRF-Token'] = token;
  }

  // エラーハンドリングの設定
  axios.interceptors.response.use(
    response => response,
    error => {
      if (error.response?.status === 422) {
        console.error('CSRF token verification failed');
        // トークンを再取得して再試行するロジックをここに追加できます
      }
      return Promise.reject(error);
    }
  );
};
setupAxios();
</script>

<template>
  <div>
    <!-- <HeaderPage :in-login="" :in-register="" :login-check=""></HeaderPage> -->
    <HeaderPage/>
  </div>
  <div>
    <RouterView></RouterView>
  </div>
</template>
