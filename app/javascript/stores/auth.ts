import { defineStore } from "pinia";

//型定義
interface User {
  created_at: string
  updated_at: string
  id: number
  name: string
  email: string
  password_digest: string
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
      sessionStorage.setItem('auth', JSON.stringify({
        isAuthenticated: this.isAuthenticated,
        user: this.user,
      }));
    },

    //ログアウト時
    clearAuth(): void {
      this.user = null;
      this.isAuthenticated = false;
      sessionStorage.removeItem('auth');
    },

    //認証状態セーブ
    initializeAuthState(): void {
      const savedAuth = sessionStorage.getItem('auth');
      if(savedAuth) {
        const authData = JSON.parse(savedAuth);
        this.user = authData.user;
        this.isAuthenticated = authData.isAuthenticated;
      }
    },
  },
});