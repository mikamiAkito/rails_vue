<script setup lang="ts">
import { onMounted, ref, Ref } from 'vue';
import { Router, useRouter } from 'vue-router';

const props: {
    readonly id?: string | undefined;
  } = defineProps({
  id: String,
});
console.log(props.id);
// const route: Router = useRouter();

onMounted(() => {
});
</script>

<template>
  <div class="text-green-700 absolute top-32">
    こちらは詳細ページです
  </div>
</template>

<style>
</style>