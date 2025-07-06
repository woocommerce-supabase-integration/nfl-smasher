# Usage Guide

## Development Setup

### Prerequisites
- Node.js 18+ and pnpm
- Git
- Gitpod account (optional)

### Local Development (Gitpod)

1. **Open in Gitpod**
   ```bash
   # Open repository in Gitpod
   # PocketBase will auto-start on port 8090
   ```

2. **Access PocketBase Admin**
   - URL: `http://localhost:8090/_/`
   - Create admin account on first visit
   - Set up collections and schema

3. **Setup Frontend**
   ```bash
   # Create SvelteKit app
   pnpm create svelte@latest frontend
   
   # Configure SvelteKit
   cd frontend
   pnpm install
   
   # Install ShadCN Svelte
   pnpm dlx shadcn-svelte@latest init
   pnpm dlx shadcn-svelte@latest add button card table
   
   # Add PocketBase SDK
   pnpm install pocketbase zod
   ```

4. **Environment Setup**
   ```bash
   # Create .env file
   echo "VITE_POCKETBASE_URL=http://localhost:8090" > frontend/.env
   ```

## Backend (PocketBase)

### Admin Interface

Access admin at `http://localhost:8090/_/`

**Initial Setup**:
1. Create admin account
2. Set up collections (games, teams, predictions)
3. Configure authentication settings
4. Set up API rules and permissions

### Collections Schema

**games**:
```json
{
  "season": "number",
  "week": "number", 
  "date": "datetime",
  "home_team": "text",
  "away_team": "text",
  "home_score": "number",
  "away_score": "number",
  "spread": "number",
  "total": "number"
}
```

**teams**:
```json
{
  "name": "text",
  "abbreviation": "text",
  "conference": "text",
  "division": "text"
}
```

### API Endpoints

**Get all games**:
```bash
GET http://localhost:8090/api/collections/games/records
```

**Get specific game**:
```bash
GET http://localhost:8090/api/collections/games/records/{id}
```

**Create new game**:
```bash
POST http://localhost:8090/api/collections/games/records
Content-Type: application/json

{
  "season": 2023,
  "week": 1,
  "home_team": "Chiefs",
  "away_team": "Lions"
}
```

## Frontend (SvelteKit)

### Project Structure
```
frontend/
├── src/
│   ├── lib/
│   │   ├── components/
│   │   │   └── ui/           # ShadCN components
│   │   ├── pb.ts            # PocketBase client
│   │   └── schemas/         # Zod validation
│   ├── routes/
│   │   ├── +layout.svelte
│   │   ├── +page.svelte     # Home page
│   │   └── games/           # Games routes
│   └── app.html
├── static/
├── .env
└── package.json
```

### PocketBase Client Setup

```typescript
// src/lib/pb.ts
import PocketBase from 'pocketbase';

const pb = new PocketBase(import.meta.env.VITE_POCKETBASE_URL);

export default pb;
```

### Data Fetching

```typescript
// src/routes/games/+page.ts
import pb from '$lib/pb';
import type { PageLoad } from './$types';

export const load: PageLoad = async () => {
  const games = await pb.collection('games').getFullList({
    sort: '-date'
  });
  
  return {
    games
  };
};
```

### Component Example

```svelte
<!-- src/routes/games/+page.svelte -->
<script lang="ts">
  import { Button } from '$lib/components/ui/button';
  import { Card } from '$lib/components/ui/card';
  
  export let data;
</script>

<h1 class="text-3xl font-bold mb-6">NFL Games</h1>

<div class="grid gap-4">
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
</div>
```

## Deployment

### Backend (Fly.io)

1. **Install Fly CLI**
   ```bash
   curl -L https://fly.io/install.sh | sh
   ```

2. **Deploy PocketBase**
   ```bash
   flyctl auth login
   flyctl launch
   flyctl deploy
   ```

3. **Setup Domain**
   ```bash
   flyctl certs create nfl-smasher.fly.dev
   ```

### Frontend (Netlify)

1. **Build Frontend**
   ```bash
   cd frontend
   pnpm build
   ```

2. **Deploy to Netlify**
   ```bash
   # Via Netlify CLI
   netlify deploy --prod --dir=build
   
   # Or connect GitHub repo to Netlify
   ```

3. **Environment Variables**
   ```bash
   # In Netlify dashboard
   VITE_POCKETBASE_URL=https://nfl-smasher.fly.dev
   ```

## Data Import

### CSV Import
```bash
# Place CSV files in data/ directory
mkdir -p data
cp nfl_games_2023.csv data/

# Run import script (to be created)
pnpm run import-data
```

### Manual Data Entry
- Use PocketBase admin interface
- Create games via API
- Bulk import via CSV upload in admin

## Testing

### Development Testing
```bash
# Run frontend tests
cd frontend
pnpm test

# Run E2E tests
pnpm test:e2e
```

### API Testing
```bash
# Test PocketBase API
curl http://localhost:8090/api/collections/games/records

# Test with authentication
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://localhost:8090/api/collections/games/records
```

## Common Tasks

### Add New UI Component
```bash
cd frontend
pnpm dlx shadcn-svelte@latest add dialog
```

### Update PocketBase Schema
1. Open admin interface
2. Navigate to Collections
3. Modify schema
4. Update frontend types

### Import New Data
```bash
# Add CSV to data/ directory
# Run import script
pnpm run import-data --file data/new_games.csv
```

### Deploy Updates
```bash
# Deploy backend
flyctl deploy

# Deploy frontend
cd frontend
pnpm build
netlify deploy --prod
```
