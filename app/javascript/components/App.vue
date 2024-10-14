<script setup>
import { RouterLink, RouterView } from 'vue-router';

</script>

<template>
  <div>
    <h1 class="text-blue-600 text-2xl text-center">Welcome to Vue + Rails</h1>
  </div>
  <nav>
    <RouterLink to="/Home" class="text-green-600">Home</RouterLink>
  </nav>
  <RouterView></RouterView>
</template>
