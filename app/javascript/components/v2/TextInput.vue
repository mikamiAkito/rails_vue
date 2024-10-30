<script setup lang="ts">
import { onMounted, Ref, ref } from 'vue';

defineProps(['modelValue']);

const emit = defineEmits(['update:modelValue']);

const input: Ref<any> = ref(null);

const handleInput: (event: Event) => void = (event: Event) => {
    if(event.target){
        const value: string = (event.target as HTMLInputElement).value
        emit('update:modelValue', value);
    }
};

onMounted(() => {
    if (input.value.hasAttribute('autofocus')) {
        input.value.focus();
    }
});

defineExpose({ focus: () => input.value.focus() });
</script>

<template>
    <input
        class="border-gray-300 dark:border-gray-500 dark:bg-slate-600 focus:border-indigo-500 focus:ring-indigo-500 rounded-md shadow-sm"
        :value="modelValue"
        @input="handleInput"
        ref="input"
    />
</template>
