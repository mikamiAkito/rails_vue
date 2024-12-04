<script setup lang="ts">
import axios from 'axios';
import InputError from '../v2/InputError.vue';
import InputLabel from '../v2/InputLabel.vue';
import PrimaryButton from '../v2/PrimaryButton.vue';
import TextInput from '../v2/TextInput.vue';
import { Ref, ref } from 'vue';
import { useAuthStore } from '@/stores/auth';
import { useRouter } from 'vue-router';

//型定義
interface FormType {
  current_password: string,
  password: string,
  password_confirmation: string,
};

const router = useRouter();
const auth = useAuthStore();
let buttonFlg: Ref<boolean> = ref(true);
const passwordInput: Ref<any> = ref(null);
const currentPasswordInput: Ref<any> = ref(null);
const form: FormType = {
  current_password: '',
  password: '',
  password_confirmation: '',
}

const buttonActive: () => void = () => {
  if(form.current_password && form.password && form.password_confirmation) {
    buttonFlg.value = false;
  }
};

const updatePasswordApi: () => void = async () => {
  await axios.patch("/updatedpassword", {user: form})
  .then((responce) => {
    console.log(responce.data.message);
    alert("パスワードを更新しました");
    location.reload();
  })
  .catch((error) => {
    console.log(error);
    switch(error.status) {
      case 422:
        if(error.code == 1) {
          error.response.data.message = "パスワードの更新でエラーが発生しました";
        };
        alert(error.response.data.message);
      break;
      case 404:
        axios.delete('/logout')
        .then((responce) => {
          console.log(responce.data.message);
          auth.clearAuth();
          router.push({
            name: 'Home'
          });
        })
        .catch((error) => {
          console.log("エラーが発生しました",[error]);
        });
        alert(error.response.data.message);
      break;
      default:
        alert(error.response.data.message);
      break;
    };
    location.reload();
  });
}
</script>

<template>
  <section>
    <header>
      <h2 class="text-lg font-medium text-gray-900 dark:text-white">パスワード更新</h2>

      <p class="mt-1 text-sm text-gray-600 dark:text-gray-400">
        Ensure your account is using a long, random password to stay secure.
      </p>
    </header>

    <form @submit.prevent="updatePasswordApi" class="mt-6 space-y-6">
      <div>
        <InputLabel for="current_password" value="現在のパスワード" />

        <TextInput
          id="current_password"
          ref="currentPasswordInput"
          v-model="form.current_password"
          type="password"
          class="mt-1 block w-full"
          autocomplete="current-password"
          @change="buttonActive"
        />

        <!-- <InputError :message="form.errors.current_password" class="mt-2" /> -->
      </div>

      <div>
        <InputLabel for="password" value="新しいパスワード" />

        <TextInput
          id="password"
          ref="passwordInput"
          v-model="form.password"
          type="password"
          class="mt-1 block w-full"
          autocomplete="new-password"
          @change="buttonActive"
        />

        <!-- <InputError :message="form.errors.password" class="mt-2" /> -->
      </div>

      <div>
        <InputLabel for="password_confirmation" value="パスワードの確認" />

        <TextInput
          id="password_confirmation"
          v-model="form.password_confirmation"
          type="password"
          class="mt-1 block w-full"
          autocomplete="new-password"
          @change="buttonActive"
        />

        <!-- <InputError :message="form.errors.password_confirmation" class="mt-2" /> -->
      </div>

      <div class="flex items-center gap-4">
        <button
        :disabled="buttonFlg"
        type="submit"
        class="inline-flex items-center px-4 py-2 bg-gray-800 dark:bg-gray-700 border border-transparent rounded-md font-semibold text-xs text-white uppercase tracking-widest hover:bg-gray-700 dark:hover:bg-gray-400 focus:bg-gray-700 active:bg-gray-900 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 transition ease-in-out duration-150">
          更新
        </button>
      </div>
    </form>
  </section>
</template>
