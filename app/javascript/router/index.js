import { createRouter, createWebHistory } from 'vue-router'
import Home from '../components/v1/Home.vue'
import Register from '../components/Auth/Register.vue'
import Login from '../components/Auth/Login.vue'
import UserDtail from '../components/v1/UserDtail.vue'
import App from '../components/App.vue'
import { useAuthStore } from '../stores/auth.ts'//import名に{}をつけないとエラーが発生する

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },

  {
    path: '/Register',
    name: 'Register',
    component: Register,
    meta: {requiresGuest: true},
  },

  {
    path: '/Login',
    name: 'Login',
    component: Login,
    meta: {requiresGuest: true},
  },

  {
    path: '/users/:id',
    name: 'UserDtail',
    component: UserDtail,
    // props: true,//プロップスで受け取る場合
    meta: {requiresAuth: true},
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes
});

//ナビゲーションガード
router.beforeEach((to, from, next) => {
  const auth = useAuthStore();

  //ログインが必要なルート
  if(to.meta.requiresAuth && !auth.isAuthenticated) {
    next('/Login');
  }
  //ログイン状態の場合に不必要なルート
  else if(to.meta.requiresGuest && auth.isAuthenticated) {
    next('/');
  }
  //その他の場合は通常のルート
  else {
    next();
  }
});

export default router
