<script setup lang="ts">
import axios from 'axios';
import InputError from '../v2/InputError.vue';
import InputLabel from '../v2/InputLabel.vue';
import PrimaryButton from '../v2/PrimaryButton.vue';
import TextInput from '../v2/TextInput.vue';
import { useAuthStore } from '@/stores/auth';
import { onMounted, Ref, ref, watch } from 'vue';

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

interface profileparams {
    name: string | undefined;
    email: string | undefined;
};

const auth = useAuthStore();
const buttonFlg: Ref<boolean> = ref(true);
const userName: Ref<string | undefined> = ref('');
const userEmail: Ref<string | undefined> = ref('');

const props = defineProps({
    mustVerifyEmail: Boolean,
    status: String,
});

const updateprofileApi: () => void = async () => {
    alert("プロフィール編集開始");
    const form: profileparams = {
        name: userName.value,
        email: userEmail.value
    };
    await axios.patch("/updateprofile", {user: form})
    .then((response) => {
        alert(response.data.message);
        user.id = response.data.id;
		user.name = response.data.name;
		user.email = response.data.email;
		user.profile_photo = response.data.profile_photo;
		user.cover_photo = response.data.cover_photo;
		user.password_digest = response.data.password_digest;
		user.created_at = response.data.created_at;
		user.updated_at = response.data.updated_at;

        auth.setAuth(user);
        location.reload();
    })
    .catch((error) => {
        alert(error.response.data.message);
        location.reload();
    });
};

onMounted(() => {
    userName.value = auth.user?.name;
    userEmail.value = auth.user?.email;
});

watch([userName, userEmail], ([newName, newEmail], [oldName, oldEmail]) => {
    if(oldName != '' && oldEmail != '') {
        buttonFlg.value = false;
    };
});
</script>

<template>
    <section>
        <header>
            <h2 class="text-lg font-medium text-gray-900 dark:text-white">プロフィール情報</h2>

            <p class="mt-1 text-sm text-gray-600 dark:text-gray-400">
                Update your account's profile information and email address.
            </p>
        </header>

        <form @submit.prevent="updateprofileApi" class="mt-6 space-y-6">
            <div>
                <InputLabel for="name" value="名前" />

                <TextInput
                    id="name"
                    type="text"
                    class="mt-1 block w-full"
                    v-model="userName"
                    required
                    autofocus
                    autocomplete="name"
                />

                <!-- <InputError class="mt-2" :message="form.errors.name" /> -->
            </div>

            <div>
                <InputLabel for="email" value="メールアドレス" />

                <TextInput
                    id="email"
                    type="email"
                    class="mt-1 block w-full"
                    v-model="userEmail"
                    required
                    autocomplete="username"
                />

                <!-- <InputError class="mt-2" :message="form.errors.email" /> -->
            </div>

            <div>
                <p class="text-sm mt-2 text-gray-800">
                    Your email address is unverified.
                    <!-- <Link
                        :href=""
                        method="post"
                        as="button"
                        class="underline text-sm text-gray-600 hover:text-gray-900 rounded-md focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                    >
                        Click here to re-send the verification email.
                    </Link> -->
                </p>

                <div
                    v-show="props.status === 'verification-link-sent'"
                    class="mt-2 font-medium text-sm text-green-600"
                >
                    A new verification link has been sent to your email address.
                </div>
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
