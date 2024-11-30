<script setup lang="ts">
import SnsIcon from '../v2/SnsIcon.vue';
import axios from 'axios';
import { RouterLink } from 'vue-router';
import InputError from '../v2/InputError.vue';
import Checkbox from '../v2/Checkbox.vue';
import { useAuthStore } from '@/stores/auth';
import { useRouter } from 'vue-router';

//型定義
interface User {
  created_at: string
  updated_at: string
  id: number
  name: string
  email: string
  profile_photo: string | undefined
  cover_photo: string | undefined
  password_digest: string
};

defineProps({
	canResetPassword: Boolean,
	status: String,
});

const form: {email: string, password: string, remember: boolean} = {
	email: '',
	password: '',
	remember: false,
};
const user: User = {
	created_at: '',
  updated_at: '',
  id: 0,
  name: '',
  email: '',
  profile_photo: undefined,
  cover_photo: undefined,
  password_digest: '',
};

const auth = useAuthStore();
const router = useRouter();

const submit: () => Promise<void> = async () => {
	await axios.post('/login', {
		session: {//受け取り側のコントローラーのparamsと合わせる
			email: form.email,
			password: form.password,
		}
	})
	.then((responce) => {
		console.log("レスポンス成功", responce);

		user.id = responce.data.id;
		user.name = responce.data.name;
		user.email = responce.data.email;
		user.profile_photo = responce.data.profile_photo;
		user.cover_photo = responce.data.cover_photo;
		user.password_digest = responce.data.password_digest;
		user.created_at = responce.data.created_at;
		user.updated_at = responce.data.updated_at;

		auth.setAuth(user);
		router.push({
			name: "Home"
		});
	})
	.catch((error) => {
		console.log("レスポンス失敗", error);
		auth.clearAuth();
		alert(error.response.data.message);
	});
};
</script>

<template>
<div>
	<div class="min-h-screen bg-gray-100 dark:bg-gray-800 flex flex-col justify-center py-12 sm:px-6 lg:px-8">
			<div class="sm:mx-auto sm:w-full sm:max-w-md">
					<h2 class="mt-6 text-center text-3xl font-extrabold text-gray-900 dark:text-white">
							アカウントにサインイン
					</h2>
					<p class="mt-2 text-center text-sm text-gray-600 dark:text-gray-400 max-w">
							または
							<RouterLink
							to="/Register"
							class="font-medium text-blue-600 hover:text-blue-500"
							>
									アカウントを作成する
							</RouterLink>
					</p>
			</div>

			<div class="mt-8 sm:mx-auto sm:w-full sm:max-w-md">
					<div class="bg-white dark:bg-gray-600 py-8 px-4 shadow sm:rounded-lg sm:px-10">
							<form @submit.prevent="submit" class="space-y-6">
									<div>
											<label for="email" class="block text-sm font-medium text-gray-700 dark:text-white">
													メールアドレス
											</label>
											<div class="mt-1">
													<input id="email" name="email" type="email" autocomplete="email" required v-model="form.email"
															class="appearance-none rounded-md relative block w-full px-3 py-2 dark:bg-slate-800 border border-gray-300 dark:border-gray-500 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
															placeholder="Enter your email address">
													<!-- <InputError class="mt-2" :message="" /> -->
											</div>
									</div>

									<div>
											<label for="password" class="block text-sm font-medium text-gray-700 dark:text-white">
													パスワード
											</label>
											<div class="mt-1">
													<input id="password" name="password" type="password" autocomplete="current-password" required v-model="form.password"
															class="appearance-none rounded-md relative block w-full px-3 py-2 dark:bg-slate-800 border border-gray-300 dark:border-gray-500 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
															placeholder="Enter your password">
													<!-- <InputError class="mt-2" :message="form.errors.password" /> -->
											</div>
									</div>

									<div class="flex items-center justify-between">
											<div class="flex items-center">
													<label for="remember_me" class="ml-2 block text-sm text-gray-900 dark:text-white">
															<Checkbox name="remember" :checked="form.remember" />
															保存
													</label>
											</div>

											<!-- <div class="text-sm">
													<Link
													v-if="canResetPassword"
													:href="route('password.request')"
													class="font-medium text-blue-600 hover:text-blue-500"
													>
															パスワードをお忘れの方
													</Link>
											</div> -->
									</div>

									<div>
											<button type="submit"
													class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">

													サインイン
											</button>
									</div>
							</form>
							<div class="mt-6">

									<div class="relative">
											<div class="absolute inset-0 flex items-center">
													<div class="w-full border-t border-gray-300"></div>
											</div>
											<div class="relative flex justify-center text-sm">
													<span class="px-2 bg-gray-100 dark:bg-gray-600 text-gray-500 dark:text-white">
															またはこちらから
													</span>
											</div>
									</div>
									<SnsIcon/>
							</div>
					</div>
			</div>
	</div>
</div>
</template>
