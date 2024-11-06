<script setup lang="ts">
import { onMounted } from 'vue';

const props: {
  profilePhotoUrl?: string | undefined;
  coverPhotoUrl?: string | undefined;
} = defineProps({
  profilePhotoUrl: String,
  coverPhotoUrl: String
});

//デフォルト画像
const defaultCoverUrl = '/img/background137.jpg';
const defaultProfileUrl = '/img/original.jpg';
const coverimage: HTMLElement | null = document.getElementById("coverImage");
const profileimage: HTMLElement | null = document.getElementById("profileImage");

const profilebutton: () => void = () => {
  if (profileimage) {
    profileimage.click();
  }
}

const coverbutton: () => void = () => {
  if (coverimage) {
    coverimage.click();
  }
}

// //画像アップデート処理
// const profileUpdate = (field) => {
//   //プロフィール画像
//   if (field === 'profile_photo') {
//     form.post(route('profile.image'), {
//       preserveScroll: true,
//       forceFormData: true,
//       onSuccess: () => form.reset('profile_photo'),
//     });
//   }
//   //背景画像
//   if (field === 'cover_photo') {
//     form.post(route('profile.image'), {
//       preserveScroll: true,
//       forceFormData: true,
//       onSuccess: () => form.reset('cover_photo'),
//     });
//   }
// };

//データフォーム
const form = {
  profile_photo: null,
  cover_photo: null,
};
</script>

<template>
  <div>
    <!-- 背景画像 -->
    <div class="flex relative">
      <img :src="props.coverPhotoUrl === '' ? defaultCoverUrl : props.coverPhotoUrl" alt="User Cover" class=" w-full xl:h-[20rem] lg:h-[18rem] md:h-[16rem] sm:h-[14rem] xs:h-[11rem]" />
      <button class="absolute bottom-2 w-full text-2xl duration-300 cursor-pointer opacity-30 hover:opacity-100 flex justify-center z-60" @click="coverbutton" type="button">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 mr-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z" />
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 13a3 3 0 11-6 0 3 3 0 016 0z" />
        </svg>
        <div>画像を選択</div>
      </button>
      <!-- <input id="coverImage" type="file" class="hidden" @change="form.cover_photo = $event.target.files[0]; profileUpdate('cover_photo')"> -->
    </div>
    <!-- <InputError class="mt-2" :message="form.errors.profile_photo" />
    <InputError class="mt-2" :message="form.errors.cover_photo" /> -->
    <!-- プロフィール画像 -->
    <div class="sm:w-[80%] xs:w-[90%] mx-auto flex relative">
      <img :src="props.profilePhotoUrl === '' ? defaultProfileUrl : props.profilePhotoUrl" alt="User Profile" class="rounded-md lg:w-[12rem] lg:h-[12rem] md:w-[10rem] md:h-[10rem] sm:w-[8rem] sm:h-[8rem] xs:w-[7rem] xs:h-[7rem] outline outline-2 outline-offset-2 outline-blue-500 relative lg:bottom-[5rem] sm:bottom-[4rem] xs:bottom-[3rem]" />
      <button class="absolute top-6 w-28 sm:w-32 md:top-14 md:w-40 lg:top-[4.5rem] lg:w-48 duration-300 cursor-pointer opacity-30 hover:opacity-100 flex justify-center" @click="profilebutton" type="button">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z" />
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 13a3 3 0 11-6 0 3 3 0 016 0z" />
        </svg>
        <div>画像を選択</div>
      </button>
      <!-- <input id="profileImage" type="file" class="hidden" @change="form.profile_photo = $event.target.files[0]; profileUpdate('profile_photo')"> -->
      
      <!-- 名前 -->
      <h1 class="w-full text-left my-4 sm:mx-4 xs:pl-4 text-gray-800 dark:text-white lg:text-4xl md:text-3xl sm:text-3xl xs:text-xl font-serif">
        <!-- {{ $page.props.auth.user.name }} -->
      </h1>
    </div>
  </div>
</template>