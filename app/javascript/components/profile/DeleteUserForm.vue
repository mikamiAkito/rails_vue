<script setup lang="ts">
import axios from 'axios';
import InputLabel from '../v2/InputLabel.vue';
import Modal from '../v2/Modal.vue';
import TextInput from '../v2/TextInput.vue';
import { useAuthStore } from '@/stores/auth';
import { useRouter } from 'vue-router';
import { nextTick, Ref, ref } from 'vue';

const confirmingUserDeletion: Ref<boolean> = ref(false);
const passwordInput: Ref<any> = ref(null);
const auth = useAuthStore();
const router = useRouter();

const form: {password: string} = {
    password: '',
};

const confirmUserDeletion: () => void = () => {
    confirmingUserDeletion.value = true;

    nextTick(() => passwordInput.value.focus());
};

const deleteUser: () => void = async () => {
    if(auth.user) {
        await axios.delete(`/v1/users/${auth.user.id}`, {
            params: {
                password: form.password,
            }
        })
        .then((responce) => {
            alert(responce.data.message);
            auth.clearAuth();
            router.push({
                name: 'Home',
            });
        })
        .catch((error) => {
            alert(error.response.data.message);
        });
    }
};

const closeModal: () => void = () => {
    confirmingUserDeletion.value = false;

    form.password = '';
};
</script>

<template>
    <section class="space-y-6">
        <header>
            <h2 class="text-lg font-medium text-gray-900 dark:text-white">アカウントを削除</h2>

            <p class="mt-1 text-sm text-gray-600 dark:text-gray-500">
                Once your account is deleted, all of its resources and data will be permanently deleted. Before deleting
                your account, please download any data or information that you wish to retain.
            </p>
        </header>

        <button method="post" @click="confirmUserDeletion" class="inline-flex items-center px-4 py-2 bg-red-600 border border-transparent rounded-md font-semibold text-xs text-white uppercase tracking-widest hover:bg-red-500 active:bg-red-700 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-2 transition ease-in-out duration-150">アカウントを削除</button>
        <Modal :show="confirmingUserDeletion" @close="closeModal">
            <div class="p-6">
                <h2 class="text-lg font-medium text-gray-900 dark:text-white">
                    本当にアカウントを削除してもよろしいですか?
                </h2>

                <p class="mt-1 text-sm text-gray-500">
                    アカウントを削除すると、そのリソースとデータはすべて永久に削除されます。アカウントを永久に削除することを確認するには、パスワードを入力してください。
                </p>

                <div class="mt-6">
                    <InputLabel for="password" value="Password" class="sr-only" />

                    <TextInput
                        id="password"
                        ref="passwordInput"
                        v-model="form.password"
                        type="password"
                        class="mt-1 block w-3/4"
                        placeholder="Password"
                        @keyup.enter="deleteUser"
                    />

                    <!-- <InputError :message="form.errors.password" class="mt-2" /> -->
                </div>

                <div class="mt-6 flex justify-end">
                    <button class="inline-flex items-center mr-3 px-4 py-2 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-700 rounded-md font-semibold text-xs text-gray-700 dark:text-white uppercase tracking-widest shadow-sm hover:bg-gray-50 dark:hover:bg-gray-400 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 disabled:opacity-25 transition ease-in-out duration-150" @click="closeModal"> キャンセル </button>
                    <button @click="deleteUser" class="inline-flex items-center px-4 py-2 bg-red-600 border border-transparent rounded-md font-semibold text-xs text-white uppercase tracking-widest hover:bg-red-500 active:bg-red-700 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-2 transition ease-in-out duration-150">アカウントを削除</button>
                </div>
            </div>
        </Modal>
    </section>
</template>
