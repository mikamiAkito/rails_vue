import { defineStore } from 'pinia';

interface shops {
  ramenShops: Object
};

export const useRamenStore = defineStore('ramenShops', {
  state: (): shops => ({
    ramenShops: {}
  })
});