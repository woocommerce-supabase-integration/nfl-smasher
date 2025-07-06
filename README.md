# NFL Smasher

Predict NFL winners, spreads, and totals using:
- **PocketBase** (backend)
- **SvelteKit** (frontend)
- **ShadCN Svelte** (UI components)
- **Zod** (validation)
- **TypeScript**
- **OOP-based architecture**

## Architecture

✅ **Development**: Gitpod environment  
✅ **Backend**: PocketBase deployed on Fly.io  
✅ **Frontend**: SvelteKit deployed on Netlify  
✅ **Database**: PocketBase built-in SQLite  

## Quick Start

### Local Development (Gitpod)

1. Open in Gitpod
2. PocketBase will auto-start on port 8090
3. Access admin UI: `http://localhost:8090/_/`

### Frontend Setup

```bash
# Create SvelteKit app
pnpm create svelte@latest frontend

# Install dependencies
cd frontend
pnpm install

# Setup ShadCN Svelte
pnpm dlx shadcn-svelte@latest init
pnpm dlx shadcn-svelte@latest add button

# Add PocketBase SDK
pnpm install pocketbase

# Start dev server
pnpm dev
```

### Deploy to Production

**Backend (Fly.io)**:
```bash
flyctl launch
flyctl deploy
```

**Frontend (Netlify)**:
```bash
cd frontend
pnpm build
# Deploy dist/ to Netlify
```

## Environment Variables

**Development**:
```env
VITE_POCKETBASE_URL=http://localhost:8090
```

**Production**:
```env
VITE_POCKETBASE_URL=https://nfl-smasher.fly.dev
```

## Documentation

- [Architecture](./docs/architecture.md)
- [Data Import](./docs/data-import.md)
- [Usage Guide](./docs/usage.md)

## Tech Stack

- **Backend**: PocketBase (Go-based BaaS)
- **Frontend**: SvelteKit + TypeScript
- **UI**: ShadCN Svelte + Tailwind CSS
- **Database**: SQLite (via PocketBase)
- **Deploy**: Fly.io (backend) + Netlify (frontend)
- **Dev**: Gitpod
