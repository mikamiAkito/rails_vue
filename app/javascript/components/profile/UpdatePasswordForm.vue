<script setup lang="ts">
import InputError from '../v2/InputError.vue';
import InputLabel from '../v2/InputLabel.vue';
import PrimaryButton from '../v2/PrimaryButton.vue';
import TextInput from '../v2/TextInput.vue';
import { Ref, ref } from 'vue';

//型定義
interface FormType {
  current_password: string,
  password: string,
  password_confirmation: string,
  processing: string,
  recentlySuccessful: string,
};

const passwordInput: Ref<any> = ref(null);
const currentPasswordInput: Ref<any> = ref(null);
const form: FormType = {
  current_password: '',
  password: '',
  password_confirmation: '',
  processing: '',
  recentlySuccessful: '',
}

const updatePassword: () => void = () => {
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

    <form @submit.prevent="updatePassword" class="mt-6 space-y-6">
      <div>
        <InputLabel for="current_password" value="現在のパスワード" />

        <TextInput
          id="current_password"
          ref="currentPasswordInput"
          v-model="form.current_password"
          type="password"
          class="mt-1 block w-full"
          autocomplete="current-password"
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
        />

        <!-- <InputError :message="form.errors.password" class="mt-2" /> -->
      </div>

      <div>
        <InputLabel for="password_confirmation" value="パスワード認証" />

        <TextInput
          id="password_confirmation"
          v-model="form.password_confirmation"
          type="password"
          class="mt-1 block w-full"
          autocomplete="new-password"
        />

        <!-- <InputError :message="form.errors.password_confirmation" class="mt-2" /> -->
      </div>

      <div class="flex items-center gap-4">
        <!-- <PrimaryButton :disabled="form.processing">更新</PrimaryButton> -->

        <Transition enter-from-class="opacity-0" leave-to-class="opacity-0" class="transition ease-in-out">
            <p v-if="form.recentlySuccessful" class="text-sm text-gray-600">Saved.</p>
        </Transition>
      </div>
    </form>
  </section>
</template>
