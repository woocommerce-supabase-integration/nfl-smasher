# Frontend Setup Instructions

## Step-by-Step SvelteKit + ShadCN Setup

### 1. Create SvelteKit Project

```bash
# Create new SvelteKit app (using new CLI)
npx sv create frontend

# Choose these options:
# ✓ Skeleton project
# ✓ Add TypeScript? Yes
# ✓ Add ESLint? Yes  
# ✓ Add Prettier? Yes
# ✓ Add Playwright? No

cd frontend
pnpm install
```

### 2. Install and Configure ShadCN Svelte

```bash
# Initialize ShadCN Svelte
pnpm dlx shadcn-svelte@latest init

# Choose these options:
# ✓ Type of project: sveltekit
# ✓ Where should I install components: src/lib/components
# ✓ Which styles to use: tailwindcss
# ✓ Use App Directory: Yes
```

### 3. Install Core Dependencies

```bash
# Install PocketBase SDK and validation
pnpm install pocketbase zod

# Install additional ShadCN components
pnpm dlx shadcn-svelte@latest add button card table dialog form input label
```

### 4. Environment Configuration

```bash
# Create environment file
echo "VITE_POCKETBASE_URL=http://localhost:8090" > .env
```

### 5. Setup PocketBase Client

Create `src/lib/pb.ts`:

```typescript
import PocketBase from 'pocketbase';

const pb = new PocketBase(import.meta.env.VITE_POCKETBASE_URL);

// Enable auto cancellation for requests
pb.autoCancellation(false);

export default pb;
```

### 6. Create Zod Schemas

Create `src/lib/schemas/game.ts`:

```typescript
import { z } from 'zod';

export const GameSchema = z.object({
  id: z.string(),
  season: z.number(),
  week: z.number(),
  date: z.string(),
  home_team: z.string(),
  away_team: z.string(),
  home_score: z.number(),
  away_score: z.number(),
  spread: z.number().optional(),
  total: z.number().optional(),
});

export type Game = z.infer<typeof GameSchema>;
```

### 7. Setup Layout

Update `src/routes/+layout.svelte`:

```svelte
<script lang="ts">
  import '../app.css';
</script>

<div class="min-h-screen bg-background">
  <header class="border-b">
    <div class="container mx-auto px-4 py-4">
      <h1 class="text-2xl font-bold">NFL Smasher</h1>
    </div>
  </header>
  
  <main class="container mx-auto px-4 py-8">
    <slot />
  </main>
</div>
```

### 8. Create Games Page

Create `src/routes/games/+page.ts`:

```typescript
import pb from '$lib/pb';
import type { PageLoad } from './$types';

export const load: PageLoad = async () => {
  try {
    const games = await pb.collection('games').getFullList({
      sort: '-date',
      limit: 50
    });
    
    return {
      games
    };
  } catch (error) {
    console.error('Failed to load games:', error);
    return {
      games: []
    };
  }
};
```

### 9. Development Commands

Add to `package.json` scripts:

```json
{
  "scripts": {
    "dev": "vite dev",
    "build": "vite build",
    "preview": "vite preview",
    "check": "svelte-kit sync && svelte-check --tsconfig ./tsconfig.json",
    "lint": "prettier --check . && eslint .",
    "format": "prettier --write ."
  }
}
```

### 10. Start Development

```bash
# Start development server
pnpm dev

# Access app at http://localhost:5173
# PocketBase admin at http://localhost:8090/_/
```

## Next Steps

1. **Setup PocketBase Collections**: Create `games` and `teams` collections
2. **Import Sample Data**: Add CSV files and create import script
3. **Add More Features**: Authentication, predictions, data visualization
4. **Deploy**: Build and deploy to Netlify
