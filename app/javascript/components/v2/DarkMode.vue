<script setup lang="ts">
import { onMounted } from 'vue';
import { useDarkModeStore } from '@/stores/isDarkMode';

const Mode = useDarkModeStore();
// const isDarkMode = ref(false);

//スタイル変更処理
const toggleDarkMode: () => void = () => {
    //ライトモードへ変更
    if(Mode.isDarkMode){
        document.documentElement.classList.remove('dark');
        localStorage.theme = 'light';
        Mode.isDarkMode = !Mode.isDarkMode;
    }else{
    //ダークモードへ変更
        document.documentElement.classList.add('dark');
        localStorage.theme = 'dark';
        Mode.isDarkMode = !Mode.isDarkMode;
    }
}

//マウント時ダークモードボタンのスタイル反映
onMounted(() => {
    const saveTheme = localStorage.theme;
    if(saveTheme === 'dark'){
        document.documentElement.classList.add('dark');
        Mode.isDarkMode = true;
    }else{
        document.documentElement.classList.remove('dark');
        Mode.isDarkMode = false;
    }
});
</script>

<template>
<div class="">
    <div class="z-60">
        <label for="toggleB" class="flex items-center cursor-pointer">
            <div class="relative">
            <input type="checkbox" id="toggleB" class="sr-only" @click="toggleDarkMode">
            <div class="block bg-gray-600 w-14 h-8 rounded-full"></div>
            <div class="absolute left-1 top-1 w-6 h-6 rounded-full transition"
            :class="{
                'bg-white':!Mode.isDarkMode,
                'translate-x-full':Mode.isDarkMode,
                'bg-indigo-500':Mode.isDarkMode
            }"
            ></div>
            </div>
        </label>
    </div>
</div>
</template>

<style scoped>

</style>