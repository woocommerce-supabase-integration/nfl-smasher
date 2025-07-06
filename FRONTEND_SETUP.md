# Frontend Setup Guide

Complete step-by-step instructions for setting up SvelteKit with ShadCN Svelte.

## Prerequisites

Make sure you have pnpm installed:
```bash
npm install -g pnpm
```

## Step 1: Create SvelteKit Project

```bash
# Create new SvelteKit project
pnpm create svelte@latest frontend

# When prompted, choose:
# ✓ Skeleton project
# ✓ Add TypeScript? Yes
# ✓ Add ESLint? Yes  
# ✓ Add Prettier? Yes
# ✓ Add Playwright? No (optional)

cd frontend
pnpm install
```

## Step 2: Install ShadCN Svelte

```bash
# Initialize ShadCN Svelte
pnpm dlx shadcn-svelte@latest init

# When prompted:
# ✓ Project type: sveltekit
# ✓ Components directory: src/lib/components
# ✓ Styles: tailwindcss
# ✓ Use App Directory: Yes
```

## Step 3: Install Core Dependencies

```bash
# Install PocketBase SDK and validation
pnpm install pocketbase zod

# Install additional ShadCN components
pnpm dlx shadcn-svelte@latest add button card table dialog input label
```

## Step 4: Environment Setup

Create environment file:
```bash
# Create .env file
echo "VITE_POCKETBASE_URL=http://localhost:8090" > .env
```

## Step 5: PocketBase Client Setup

Create PocketBase client:
```typescript
// src/lib/pb.ts
import PocketBase from 'pocketbase';

const pb = new PocketBase(import.meta.env.VITE_POCKETBASE_URL);

// Enable auto-cancellation for better performance
pb.autoCancellation(false);

export default pb;
```

## Step 6: Type Definitions

Create types for your data:
```typescript
// src/lib/types.ts
export interface Game {
  id: string;
  season: number;
  week: number;
  date: string;
  home_team: string;
  away_team: string;
  home_score: number;
  away_score: number;
  spread: number;
  total: number;
  created: string;
  updated: string;
}

export interface Team {
  id: string;
  name: string;
  abbreviation: string;
  conference: string;
  division: string;
  created: string;
  updated: string;
}
```

## Step 7: Zod Schemas

Create validation schemas:
```typescript
// src/lib/schemas/game.ts
import { z } from 'zod';

export const GameSchema = z.object({
  season: z.number().min(1920).max(2030),
  week: z.number().min(1).max(22),
  date: z.string().datetime(),
  home_team: z.string().min(2).max(50),
  away_team: z.string().min(2).max(50),
  home_score: z.number().min(0).max(100),
  away_score: z.number().min(0).max(100),
  spread: z.number().min(-30).max(30),
  total: z.number().min(20).max(100)
});

export type GameInput = z.infer<typeof GameSchema>;
```

## Step 8: Sample Page

Create a sample page to test everything:
```svelte
<!-- src/routes/+page.svelte -->
<script lang="ts">
  import { Button } from '$lib/components/ui/button';
  import { Card } from '$lib/components/ui/card';
  
  export let data;
</script>

<div class="container mx-auto p-4">
  <h1 class="text-3xl font-bold mb-6">NFL Smasher</h1>
  
  <div class="grid gap-4">
    {#if data.games && data.games.length > 0}
      {#each data.games as game}
        <Card class="p-4">
          <div class="flex justify-between items-center">
            <div>
              <h3 class="font-semibold">{game.away_team} @ {game.home_team}</h3>
              <p class="text-sm text-gray-500">Week {game.week}, {game.season}</p>
            </div>
            <div class="text-right">
              <p class="font-bold">{game.away_score} - {game.home_score}</p>
              <p class="text-sm">Spread: {game.spread}</p>
            </div>
          </div>
        </Card>
      {/each}
    {:else}
      <Card class="p-4">
        <p class="text-center text-gray-500">No games found. Add some games in PocketBase admin!</p>
      </Card>
    {/if}
  </div>
  
  <div class="mt-6">
    <Button href="http://localhost:8090/_/" target="_blank">
      Open PocketBase Admin
    </Button>
  </div>
</div>
```

## Step 9: Load Data

Create page load function:
```typescript
// src/routes/+page.ts
import pb from '$lib/pb';
import type { PageLoad } from './$types';

export const load: PageLoad = async () => {
  try {
    const games = await pb.collection('games').getFullList({
      sort: '-date',
      limit: 10
    });
    
    return {
      games
    };
  } catch (error) {
    console.error('Error loading games:', error);
    return {
      games: []
    };
  }
};
```

## Step 10: Update App Layout

Update the main layout:
```svelte
<!-- src/app.html -->
<!DOCTYPE html>
<html lang="en" class="%sveltekit.theme%">
  <head>
    <meta charset="utf-8" />
    <link rel="icon" href="%sveltekit.assets%/favicon.png" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    %sveltekit.head%
  </head>
  <body data-sveltekit-preload-data="hover" class="min-h-screen bg-background">
    <div style="display: contents">%sveltekit.body%</div>
  </body>
</html>
```

## Step 11: Start Development

```bash
# Start development server
pnpm dev

# Open in browser
open http://localhost:5173
```

## Step 12: Production Build

```bash
# Build for production
pnpm build

# Preview production build
pnpm preview
```

## Next Steps

1. **Add Authentication**: Implement user auth with PocketBase
2. **Create More Components**: Add prediction forms, team pages, etc.
3. **Add State Management**: Use Svelte stores for global state
4. **Implement Real-time**: Use PocketBase real-time subscriptions
5. **Add Testing**: Set up unit and integration tests

## Troubleshooting

### Common Issues

1. **Tailwind not loading**: Check `tailwind.config.js` and `app.css`
2. **PocketBase connection**: Verify `VITE_POCKETBASE_URL` in `.env`
3. **TypeScript errors**: Ensure all types are properly imported
4. **Build errors**: Check for missing dependencies

### Useful Commands

```bash
# Add new ShadCN component
pnpm dlx shadcn-svelte@latest add [component-name]

# Update dependencies
pnpm update

# Check for issues
pnpm lint
pnpm check
```

## File Structure

Your final frontend structure should look like:

```
frontend/
├── src/
│   ├── lib/
│   │   ├── components/
│   │   │   └── ui/           # ShadCN components
│   │   ├── pb.ts            # PocketBase client
│   │   ├── types.ts         # TypeScript types
│   │   └── schemas/         # Zod schemas
│   ├── routes/
│   │   ├── +layout.svelte
│   │   ├── +page.svelte
│   │   └── +page.ts
│   ├── app.html
│   └── app.css
├── static/
├── .env
├── package.json
├── tailwind.config.js
├── postcss.config.js
└── vite.config.ts
```

You're now ready to build your NFL prediction app! 🏈
