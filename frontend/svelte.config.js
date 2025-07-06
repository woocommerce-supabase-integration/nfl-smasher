import adapter from '@sveltejs/adapter-netlify';
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';

/** @type {import('@sveltejs/kit').Config} */
const config = {
	// Consult https://svelte.dev/docs/kit/integrations
	// for more information about preprocessors
	preprocess: vitePreprocess(),

	kit: {
		// Using Netlify adapter for deployment to Netlify
		// See https://svelte.dev/docs/kit/adapters for more information about adapters.
		adapter: adapter({
			// Optional: configure the adapter
			edge: false,
			split: false
		})
	}
};

export default config;
