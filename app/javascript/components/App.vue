<script setup lang="ts">
import { RouterView } from 'vue-router';
import HeaderPage from './v1/HeaderPage.vue';
import axios from 'axios';
import { onMounted, Ref, ref } from 'vue';
import { useAuthStore } from '@/stores/auth';

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

const auth = useAuthStore();

onMounted(() => {
  setupAxios();
  auth.initializeAuthState();
});
</script>

<template>
  <div>
    <HeaderPage/>
  </div>
  <div>
    <RouterView/>
  </div>
</template>
