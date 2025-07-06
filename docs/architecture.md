# Architecture

## Overview

NFL Smasher uses a modern full-stack architecture with clear separation between frontend, backend, and deployment layers.

## Frontend

- **Framework**: SvelteKit with TypeScript
- **UI Components**: ShadCN Svelte + Tailwind CSS
- **State Management**: Svelte stores + PocketBase real-time subscriptions
- **API Client**: PocketBase JavaScript SDK
- **Deployment**: Netlify (static site generation)

## Backend

- **Database**: PocketBase (Go-based BaaS with SQLite)
- **API**: Auto-generated REST API via PocketBase
- **Admin UI**: Built-in PocketBase admin interface
- **Authentication**: PocketBase auth (users, sessions, OAuth)
- **Deployment**: Fly.io (containerized)

## Data Flow

```
Frontend (Netlify) → REST API → PocketBase (Fly.io) → SQLite
```

1. **Data Import**: CSV files → validation → PocketBase collections
2. **Frontend**: SvelteKit fetches data via PocketBase REST API
3. **Real-time**: PocketBase handles WebSocket connections for live updates
4. **Predictions**: Future ML models will integrate via PocketBase hooks

## PocketBase Collections

### `games`
- `id`: string (auto-generated)
- `season`: number
- `week`: number
- `home_team`: string
- `away_team`: string
- `home_score`: number
- `away_score`: number
- `spread`: number
- `total`: number
- `date`: datetime

### `teams`
- `id`: string (auto-generated)
- `name`: string
- `abbreviation`: string
- `conference`: string
- `division`: string

### `predictions`
- `id`: string (auto-generated)
- `game_id`: string (relation to games)
- `predicted_winner`: string
- `predicted_spread`: number
- `predicted_total`: number
- `confidence`: number
- `model_version`: string

## Environment Architecture

### Development (Gitpod)
```
Gitpod Container
├── PocketBase (localhost:8090)
└── SvelteKit (localhost:5173)
```

### Production
```
Netlify (Frontend) → HTTPS → Fly.io (PocketBase Backend)
```

## Security

- **API**: PocketBase handles CORS, rate limiting, validation
- **Auth**: Session-based authentication via PocketBase
- **Database**: SQLite with PocketBase security layers
- **Deployment**: HTTPS enforced on both Netlify and Fly.io

## Scaling Considerations

- **Database**: SQLite suitable for MVP; can migrate to PostgreSQL later
- **Backend**: Fly.io auto-scaling containers
- **Frontend**: Netlify CDN for global distribution
- **Real-time**: PocketBase WebSocket scaling via Redis (future)
