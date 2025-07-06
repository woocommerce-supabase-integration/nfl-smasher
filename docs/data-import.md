# Data Import Process

## Overview

NFL Smasher imports historical NFL game data from CSV files and validates it using Zod schemas before storing in PocketBase collections.

## Data Sources

### Primary Source: Pro-Football-Reference
- Historical game results
- Team statistics
- Player data
- Betting lines (spreads, totals)

### CSV Format Expected

```csv
season,week,date,home_team,away_team,home_score,away_score,spread,total
2023,1,2023-09-07,Bills,Jets,16,19,-3,42.5
2023,1,2023-09-10,Chiefs,Lions,21,20,-5.5,52.5
```

## Import Process

### 1. Data Validation

Using Zod schemas to validate CSV data:

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
```

### 2. Import Script

```bash
# Place CSV files in data/ directory
mkdir -p data
cp nfl_games_2023.csv data/

# Run import script
pnpm run import-data
```

### 3. PocketBase Collections

Data is imported into these collections:

**games**:
- Stores individual game records
- Includes betting lines and results
- Linked to teams via relations

**teams**:
- NFL team information
- Conference and division data
- Team abbreviations and colors

## Import Commands

### Manual Import
```bash
# Import specific season
pnpm run import-data --season 2023

# Import specific file
pnpm run import-data --file data/custom_games.csv

# Import with validation only (no database writes)
pnpm run import-data --validate-only
```

### Bulk Import
```bash
# Import all CSV files in data/ directory
pnpm run import-data --bulk

# Import multiple seasons
pnpm run import-data --seasons 2020,2021,2022,2023
```

## Data Validation Rules

### Required Fields
- `season`: 4-digit year (1920-2030)
- `week`: Week number (1-22, including playoffs)
- `date`: ISO datetime string
- `home_team`, `away_team`: Team names
- `home_score`, `away_score`: Final scores

### Optional Fields
- `spread`: Point spread (home team perspective)
- `total`: Over/under total points
- `weather`: Weather conditions
- `attendance`: Game attendance

### Validation Errors
- **Duplicate games**: Same teams, date, and week
- **Invalid scores**: Negative or unrealistic scores
- **Missing teams**: Teams not in teams collection
- **Date format**: Non-ISO datetime strings

## Future Enhancements

### API Integration
- ESPN Sports API
- NFL.com official data
- Vegas betting lines APIs
- Weather data integration

### Automated Imports
- Scheduled cron jobs
- Email-to-API parsing
- Real-time game updates
- Webhook integrations

### Data Enrichment
- Player statistics
- Team performance metrics
- Weather conditions
- Injury reports

## Error Handling

### Common Issues
1. **CSV Format Errors**: Check column headers and data types
2. **Duplicate Records**: Use upsert logic for existing games
3. **Missing Teams**: Ensure teams collection is populated first
4. **Date Parsing**: Use consistent ISO datetime format

### Logging
```typescript
// Import logs saved to PocketBase
{
  import_id: "uuid",
  timestamp: "2023-12-01T10:30:00Z",
  file_name: "nfl_games_2023.csv",
  records_processed: 272,
  records_imported: 268,
  errors: 4,
  status: "completed"
}
```
