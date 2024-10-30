import { defineStore } from "pinia";
import { Ref, ref } from "vue";

//型定義
interface Mode {
  isDarkMode: Ref<boolean>
};

export const useDarkModeStore = defineStore('isDarkMode', {
  state: (): Mode => ({
    isDarkMode: ref(false),
  }),
})