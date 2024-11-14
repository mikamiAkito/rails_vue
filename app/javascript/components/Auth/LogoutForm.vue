<script setup lang="ts">
import axios from 'axios';
import { useAuthStore } from '@/stores/auth';
import { useRouter } from 'vue-router';

const auth = useAuthStore();
const router = useRouter();

const LogOutApi: () => void = async () => {
  const isConfirmed = window.confirm('ログアウトを実行しますか？');
  if(isConfirmed) {
    await axios.delete('/logout')
    .then((responce) => {
      console.log(responce.data.message);
      auth.clearAuth();
      router.push({
        name: 'Home'
      });
    })
    .catch((error) => {
      console.log("エラーが発生しました",[error]);
    });
  }
};
</script>

<template>
  <section class="space-y-6">
    <header>
        <h2 class="text-lg font-medium text-gray-900 dark:text-white">アカウントからログアウト</h2>
        <p class="mt-1 text-sm text-gray-600 dark:text-gray-500">
          アカウントを削除すると、そのリソースとデータはすべて永久に削除されます。アカウントを削除する前に、保持したいデータや情報をダウンロードしてください。
        </p>
    </header>
    <button method="post" @click="LogOutApi" class="inline-flex items-center px-4 py-2 bg-red-600 border border-transparent rounded-md font-semibold text-xs text-white uppercase tracking-widest hover:bg-red-500 active:bg-red-700 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-2 transition ease-in-out duration-150">ログアウト</button>
  </section>
</template>
