import { createRouter, createWebHistory } from 'vue-router'
import Home from '../components/v1/Home.vue'
import Register from '../components/Auth/Register.vue'
import Login from '../components/Auth/Login.vue'

const routes = [
  {
    path: '/Home',
    name: 'Home',
    component: Home
  },

  {
    path: '/Register',
    name: 'Register',
    component: Register
  },

  {
    path: '/Login',
    name: 'Login',
    component: Login
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
