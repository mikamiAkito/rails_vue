import { defineStore } from "pinia";

//型定義
interface User {
  id: number
  name: string
  email: string
};
interface AuthState {
  user: User | null
  isAuthenticated: boolean
  loading: boolean
};

export const useAuthStore = defineStore('auth',{
  state: (): AuthState => ({
    user: null,
    isAuthenticated: false,
    loading: false,
  }),

  getters: {
  },

  actions: {
    //ログイン成功時
    setAuth(user: User): void {
      this.user = user;
      this.isAuthenticated = true;
    },

    //ログアウト時
    clearAuth(): void {
      this.user = null;
      this.isAuthenticated = false;
    },

  },
});