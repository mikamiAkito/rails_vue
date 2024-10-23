<script setup lang="ts">
import { computed } from 'vue';

const emit: (event: "update:checked", ...args: any[]) => void = defineEmits(['update:checked']);

const props: {
		readonly checked: boolean | unknown[];
		readonly value: null;
	} = defineProps({
	checked: {
			type: [Array, Boolean],
			default: false,
	},
	value: {
			default: null,
	},
});

const proxyChecked = computed({
    get() {
        return props.checked;
    },

    set(val) {
        emit('update:checked', val);
    },
});
</script>

<template>
    <input
        type="checkbox"
        :value="value"
        v-model="proxyChecked"
        class="rounded border-gray-300 text-indigo-600 shadow-sm focus:ring-indigo-500"
    />
</template>
