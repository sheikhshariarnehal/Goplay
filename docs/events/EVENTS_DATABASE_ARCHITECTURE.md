# PlayzTV Events System - Complete Architecture

## Overview

The Events system is the core of PlayzTV's sports streaming platform. It manages live and scheduled sporting events, aggregates multiple stream sources per event, and provides unified access to global sports content.

### Key Metrics
- **Total Events**: 79 unique sporting events
- **Total Streams**: 229 alternative sources
- **Average Streams per Event**: 2.9 alternatives
- **Sports Categories**: 11 (Cricket, Football, WWE, Boxing, MMA, Motorsport, NFL, NHL, MLB, Tennis, Rugby)
- **Live Events**: 6+ currently broadcasting (as of 2026-10-25)
- **Trending Events**: 2 featured events
- **Content Providers**: 30+ streaming sources
- **Languages**: 10+ (English, Hindi, Arabic, French, Spanish, Portuguese, Tamil, Telugu, Kannada, Russian)

---

## Database Architecture

### Entity Relationship Diagram

```
┌─────────────────────────────────────┐
│           EVENTS                     │
│─────────────────────────────────────│
│ PK  id (VARCHAR)                    │
│     base_id (VARCHAR)               │
│     sport (VARCHAR)                 │
│     team1 (VARCHAR)                 │
│     team2 (VARCHAR)                 │
│     timestamp (BIGINT)              │
│     logo_url (TEXT)                 │
│     tournament_id (VARCHAR)         │
│     is_live (BOOLEAN)               │
│     is_trending (BOOLEAN)           │
│     stream_count (INT)              │
│     created_at (TIMESTAMP)          │
│     updated_at (TIMESTAMP)          │
└─────────────────┬───────────────────┘
                  │
                  │ 1:N
                  │
┌─────────────────▼───────────────────┐
│           STREAMS                    │
│─────────────────────────────────────│
│ PK  id (VARCHAR)                    │
│ FK  event_id → events.base_id       │
│     stream_number (INT)             │
│     provider_name (VARCHAR)         │
│     provider_region (VARCHAR)       │
│     language (VARCHAR)              │
│     quality (VARCHAR)               │
│     stream_url (TEXT)               │
│     stream_type (ENUM)              │
│     drm_type (VARCHAR)              │
│     drm_kid (TEXT)                  │
│     drm_key (TEXT)                  │
│     requires_headers (BOOLEAN)      │
│     headers (JSON)                  │
│     is_proxy (BOOLEAN)              │
│     sort_order (INT)                │
│     cdn_provider (VARCHAR)          │
│     created_at (TIMESTAMP)          │
└─────────────────┬───────────────────┘
                  │
                  │ N:1
                  │
┌─────────────────▼───────────────────┐
│         PROVIDERS                    │
│─────────────────────────────────────│
│ PK  id (VARCHAR)                    │
│     name (VARCHAR)                  │
│     display_name (VARCHAR)          │
│     logo_url (TEXT)                 │
│     supports_drm (BOOLEAN)          │
│     primary_sports (JSON)           │
│     regions (JSON)                  │
│     languages (JSON)                │
│     stream_count (INT)              │
│     is_active (BOOLEAN)             │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│           SPORTS                     │
│─────────────────────────────────────│
│ PK  id (VARCHAR)                    │
│     name (VARCHAR)                  │
│     display_name (VARCHAR)          │
│     icon_url (TEXT)                 │
│     event_count (INT)               │
│     live_count (INT)                │
│     sort_order (INT)                │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│         TOURNAMENTS                  │
│─────────────────────────────────────│
│ PK  id (VARCHAR)                    │
│     name (VARCHAR)                  │
│     sport_id → sports.id            │
│     logo_url (TEXT)                 │
│     season (VARCHAR)                │
│     country (VARCHAR)               │
│     event_count (INT)               │
└─────────────────────────────────────┘
```

---

## Database Schema (SQL)

### 1. Events Table

```sql
CREATE TABLE events (
    -- Primary Identification
    id VARCHAR(255) PRIMARY KEY,                    -- Full ID: event-cricket-india-vs-pak-1792330200-s1
    base_id VARCHAR(255) NOT NULL UNIQUE,           -- Base ID: event-cricket-india-vs-pak-1792330200
    
    -- Event Details
    sport VARCHAR(50) NOT NULL,                     -- cricket, football, wwe, boxing, etc.
    team1 VARCHAR(255) NOT NULL,                    -- First participant
    team2 VARCHAR(255) NOT NULL,                    -- Second participant
    title VARCHAR(500) GENERATED ALWAYS AS          -- Auto-generated: "India vs Pakistan"
        (team1 || ' vs ' || team2) STORED,
    
    -- Scheduling
    timestamp BIGINT NOT NULL,                      -- Unix timestamp (seconds)
    start_time TIMESTAMP GENERATED ALWAYS AS        -- Converted to datetime
        (to_timestamp(timestamp)) STORED,
    duration_minutes INT DEFAULT 180,               -- Estimated duration
    end_time TIMESTAMP GENERATED ALWAYS AS 
        (to_timestamp(timestamp) + interval '1 minute' * duration_minutes) STORED,
    
    -- Branding
    logo_url TEXT,                                  -- Event/tournament logo
    tournament_id VARCHAR(50),                      -- FK to tournaments (optional)
    tournament_name VARCHAR(255),                   -- Denormalized for performance
    
    -- Status Flags
    is_live BOOLEAN DEFAULT FALSE,                  -- Currently broadcasting
    is_trending BOOLEAN DEFAULT FALSE,              -- Featured/promoted
    is_upcoming BOOLEAN GENERATED ALWAYS AS         -- Future event
        (timestamp > EXTRACT(EPOCH FROM NOW())) STORED,
    is_past BOOLEAN GENERATED ALWAYS AS             -- Past event
        (timestamp < EXTRACT(EPOCH FROM NOW())) STORED,
    
    -- Metadata
    stream_count INT DEFAULT 0,                     -- Number of alternative streams
    view_count INT DEFAULT 0,                       -- Total views (if tracked)
    region_restrictions JSON,                       -- Geo-blocking info
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Indexes
    CONSTRAINT chk_timestamp CHECK (timestamp > 0),
    CONSTRAINT chk_stream_count CHECK (stream_count >= 0)
);

-- Indexes for Events
CREATE INDEX idx_events_base_id ON events(base_id);
CREATE INDEX idx_events_sport ON events(sport);
CREATE INDEX idx_events_timestamp ON events(timestamp);
CREATE INDEX idx_events_start_time ON events(start_time);
CREATE INDEX idx_events_live ON events(is_live) WHERE is_live = TRUE;
CREATE INDEX idx_events_trending ON events(is_trending) WHERE is_trending = TRUE;
CREATE INDEX idx_events_upcoming ON events(timestamp) WHERE timestamp > EXTRACT(EPOCH FROM NOW());
CREATE INDEX idx_events_tournament ON events(tournament_id) WHERE tournament_id IS NOT NULL;
CREATE INDEX idx_events_updated ON events(updated_at);

-- Full-text search index
CREATE INDEX idx_events_search ON events USING gin(
    to_tsvector('english', team1 || ' ' || team2 || ' ' || COALESCE(tournament_name, ''))
);
```

### 2. Streams Table

```sql
CREATE TABLE streams (
    -- Primary Identification
    id VARCHAR(255) PRIMARY KEY,                    -- Full channel ID
    event_id VARCHAR(255) NOT NULL,                 -- FK to events.base_id
    stream_number INT NOT NULL,                     -- s1, s2, s3, etc.
    
    -- Provider Information
    provider_name VARCHAR(100),                     -- WILLOW, FANCODE, SKY SPORTS
    provider_region VARCHAR(10),                    -- AQ, IN, US, UK, etc.
    language VARCHAR(50),                           -- EN, HINDI, ARABIC, etc.
    
    -- Stream Details
    name VARCHAR(500),                              -- Full display name
    quality VARCHAR(10) DEFAULT 'HD',               -- HD, FHD, SD
    stream_url TEXT NOT NULL,                       -- Manifest URL (.m3u8 or .mpd)
    stream_type VARCHAR(10) NOT NULL,               -- hls or dash
    
    -- DRM Configuration
    drm_type VARCHAR(20),                           -- clearkey or null
    drm_kid TEXT,                                   -- Key ID (32-char hex)
    drm_key TEXT,                                   -- Decryption key (32-char hex)
    
    -- Access Control
    requires_headers BOOLEAN DEFAULT FALSE,
    headers JSON,                                   -- HTTP headers object
    requires_auth BOOLEAN DEFAULT FALSE,
    is_proxy BOOLEAN DEFAULT FALSE,
    
    -- Infrastructure
    cdn_provider VARCHAR(50),                       -- amazon, cloudflare, akamai
    edge_location VARCHAR(50),                      -- iad-nitro, pdx-nitro, etc.
    
    -- Metadata
    sort_order INT DEFAULT 0,                       -- Display priority
    is_active BOOLEAN DEFAULT TRUE,
    failure_count INT DEFAULT 0,                    -- Track reliability
    last_verified TIMESTAMP,
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    FOREIGN KEY (event_id) REFERENCES events(base_id) ON DELETE CASCADE,
    UNIQUE(event_id, stream_number),
    CONSTRAINT chk_stream_number CHECK (stream_number > 0),
    CONSTRAINT chk_stream_type CHECK (stream_type IN ('hls', 'dash')),
    CONSTRAINT chk_drm_type CHECK (drm_type IN ('clearkey', NULL))
);

-- Indexes for Streams
CREATE INDEX idx_streams_event ON streams(event_id);
CREATE INDEX idx_streams_provider ON streams(provider_name);
CREATE INDEX idx_streams_active ON streams(is_active) WHERE is_active = TRUE;
CREATE INDEX idx_streams_sort ON streams(event_id, sort_order);
CREATE INDEX idx_streams_cdn ON streams(cdn_provider);
```

### 3. Sports Table

```sql
CREATE TABLE sports (
    id VARCHAR(50) PRIMARY KEY,                     -- cricket, football, wwe
    name VARCHAR(100) NOT NULL UNIQUE,              -- Internal name
    display_name VARCHAR(100) NOT NULL,             -- User-facing name
    icon_url TEXT,                                  -- Sport icon
    description TEXT,
    
    -- Statistics
    event_count INT DEFAULT 0,
    live_count INT DEFAULT 0,
    trending_count INT DEFAULT 0,
    
    -- Display
    sort_order INT DEFAULT 0,
    color_hex VARCHAR(7),                           -- Brand color (#FF5733)
    is_featured BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for Sports
CREATE INDEX idx_sports_sort ON sports(sort_order);
CREATE INDEX idx_sports_active ON sports(is_active) WHERE is_active = TRUE;

-- Insert default sports
INSERT INTO sports (id, name, display_name, sort_order) VALUES
('cricket', 'cricket', 'Cricket', 1),
('football', 'football', 'Football', 2),
('wwe', 'wwe', 'WWE/Wrestling', 3),
('boxing', 'boxing', 'Boxing', 4),
('mixed-martial-arts', 'mixed-martial-arts', 'MMA/UFC', 5),
('motorsport', 'motorsport', 'Motorsport', 6),
('american-football', 'american-football', 'American Football', 7),
('hockey', 'hockey', 'Hockey', 8),
('baseball', 'baseball', 'Baseball', 9),
('tennis', 'tennis', 'Tennis', 10),
('rugby', 'rugby', 'Rugby', 11);
```

### 4. Providers Table

```sql
CREATE TABLE providers (
    id VARCHAR(50) PRIMARY KEY,                     -- willow, fancode, sky
    name VARCHAR(100) NOT NULL UNIQUE,
    display_name VARCHAR(100) NOT NULL,
    logo_url TEXT,
    website_url TEXT,
    
    -- Capabilities
    supports_drm BOOLEAN DEFAULT FALSE,
    drm_types JSON,                                 -- ["clearkey", "widevine"]
    stream_types JSON,                              -- ["hls", "dash"]
    
    -- Coverage
    primary_sports JSON,                            -- ["cricket", "football"]
    regions JSON,                                   -- ["IN", "US", "UK"]
    languages JSON,                                 -- ["EN", "HINDI", "ARABIC"]
    
    -- Statistics
    stream_count INT DEFAULT 0,
    active_stream_count INT DEFAULT 0,
    reliability_score DECIMAL(3,2) DEFAULT 0.00,    -- 0.00 to 1.00
    
    -- Status
    is_active BOOLEAN DEFAULT TRUE,
    is_premium BOOLEAN DEFAULT FALSE,
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for Providers
CREATE INDEX idx_providers_active ON providers(is_active) WHERE is_active = TRUE;
CREATE INDEX idx_providers_premium ON providers(is_premium);
```

### 5. Tournaments Table

```sql
CREATE TABLE tournaments (
    id VARCHAR(50) PRIMARY KEY,                     -- From logo URLs
    name VARCHAR(255) NOT NULL,
    sport_id VARCHAR(50) NOT NULL,
    logo_url TEXT,
    
    -- Details
    season VARCHAR(50),                             -- 2026, 2026-27
    country VARCHAR(100),
    region VARCHAR(50),                             -- Europe, Asia, Americas
    level VARCHAR(50),                              -- International, National, League
    
    -- Statistics
    event_count INT DEFAULT 0,
    
    -- Status
    is_active BOOLEAN DEFAULT TRUE,
    
    -- Timestamps
    start_date DATE,
    end_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (sport_id) REFERENCES sports(id)
);

-- Indexes for Tournaments
CREATE INDEX idx_tournaments_sport ON tournaments(sport_id);
CREATE INDEX idx_tournaments_active ON tournaments(is_active) WHERE is_active = TRUE;
```

### 6. User Analytics Tables (Optional)

```sql
-- User viewing history
CREATE TABLE viewing_history (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255),                           -- Device ID or user ID
    event_id VARCHAR(255) NOT NULL,
    stream_id VARCHAR(255) NOT NULL,
    
    -- Viewing metrics
    started_at TIMESTAMP NOT NULL,
    ended_at TIMESTAMP,
    duration_seconds INT,
    
    -- Quality metrics
    buffer_count INT DEFAULT 0,
    avg_bitrate_kbps INT,
    errors JSON,
    
    FOREIGN KEY (event_id) REFERENCES events(base_id),
    FOREIGN KEY (stream_id) REFERENCES streams(id)
);

-- Stream performance tracking
CREATE TABLE stream_performance (
    id SERIAL PRIMARY KEY,
    stream_id VARCHAR(255) NOT NULL,
    
    -- Metrics
    success_count INT DEFAULT 0,
    failure_count INT DEFAULT 0,
    avg_buffer_time_ms INT,
    avg_start_time_ms INT,
    
    -- Time period
    recorded_at DATE NOT NULL,
    
    FOREIGN KEY (stream_id) REFERENCES streams(id),
    UNIQUE(stream_id, recorded_at)
);
```

---

## Data Population Example

### Sample Data Insertion

```sql
-- Insert an event
INSERT INTO events (
    id, base_id, sport, team1, team2, timestamp, 
    logo_url, tournament_id, is_live, is_trending, stream_count
) VALUES (
    'event-cricket-india-women-vs-zimbabwe-women-1792330200-s1',
    'event-cricket-india-women-vs-zimbabwe-women-1792330200',
    'cricket',
    'India Women',
    'Zimbabwe Women',
    1792330200,
    'http://img.sofascore.com/api/v1/unique-tournament/11222/image/dark',
    '11222',
    FALSE,
    FALSE,
    9
);

-- Insert multiple streams for the event
INSERT INTO streams (
    id, event_id, stream_number, provider_name, provider_region,
    name, quality, stream_url, stream_type, drm_type, drm_kid, drm_key,
    cdn_provider, sort_order
) VALUES
-- Stream 1: WILLOW with ClearKey DRM
(
    'event-cricket-india-women-vs-zimbabwe-women-1792330200-s1',
    'event-cricket-india-women-vs-zimbabwe-women-1792330200',
    1,
    'WILLOW',
    'AQ',
    'India Women vs Zimbabwe Women (WILLOW - AQ)',
    'HD',
    'https://otte.cache.aiv-cdn.net/iad-nitro/live/clients/dash/enc/oazcbevnl7/out/v1/bda05b242720469ca9fb9fabbde64cc2/cenc.mpd',
    'dash',
    'clearkey',
    'bfeaf0c7782327ca574f32b1629080b6',
    'c03b21556a4cf97130228258de3fe45d',
    'amazon',
    0
),
-- Stream 2: TNT SPORTS with ClearKey DRM
(
    'event-cricket-india-women-vs-zimbabwe-women-1792330200-s2',
    'event-cricket-india-women-vs-zimbabwe-women-1792330200',
    2,
    'TNT SPORTS',
    'AQ',
    'India Women vs Zimbabwe Women (TNT SPORTS - AQ)',
    'HD',
    'https://otte.cache.aiv-cdn.net/iad-nitro/live/clients/dash/enc/rhf2dwosdt/out/v1/ee550d2a68d846c797e6ce4de2e8b76d/cenc.mpd',
    'dash',
    'clearkey',
    '69a5aa835a061ce64a630d1046727e40',
    'd02feac8a999bd06bf4059bf33411749',
    'amazon',
    1
),
-- Stream 5: Star Sports English (India) with cookie auth
(
    'event-cricket-india-women-vs-zimbabwe-women-1792330200-s5',
    'event-cricket-india-women-vs-zimbabwe-women-1792330200',
    5,
    'STAR SPORTS',
    'IN',
    'India Women vs Zimbabwe Women (SS SPORTS EN - IN)',
    'HD',
    'https://livetv.hotstar.com/mp1/gec-india-1540068247/9a6e7c30f9194cc1a6a6250cedb115fb/index.mpd',
    'dash',
    'clearkey',
    'e85897bf6e594d698b7c82646c8e0000',
    'd2dda31234ae40538843e871cd4dcc2a',
    'hotstar',
    4
);

-- Update stream headers for Hotstar
UPDATE streams 
SET 
    requires_headers = TRUE,
    headers = '{
        "cookie": "hdntl=exp=1792177960~acl=/*~id=fda09ca3277ee6e61131f47f7f2628fd~data=hdntl~hmac=6c4850d14e3f7375f98b13608c4269f0806ebace7f1186ad44a2995aca7e69a2",
        "referer": "https://www.hotstar.com/",
        "origin": "https://www.hotstar.com"
    }'::JSON
WHERE id LIKE '%hotstar%' OR cdn_provider = 'hotstar';
```

---

## Database Triggers & Functions

### Auto-update event stream count

```sql
CREATE OR REPLACE FUNCTION update_event_stream_count()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE events
    SET stream_count = (
        SELECT COUNT(*) 
        FROM streams 
        WHERE event_id = NEW.event_id AND is_active = TRUE
    ),
    updated_at = CURRENT_TIMESTAMP
    WHERE base_id = NEW.event_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_stream_count
AFTER INSERT OR UPDATE OR DELETE ON streams
FOR EACH ROW
EXECUTE FUNCTION update_event_stream_count();
```

### Auto-update sport event counts

```sql
CREATE OR REPLACE FUNCTION update_sport_counts()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE sports
    SET 
        event_count = (
            SELECT COUNT(*) FROM events WHERE sport = NEW.sport
        ),
        live_count = (
            SELECT COUNT(*) FROM events WHERE sport = NEW.sport AND is_live = TRUE
        ),
        updated_at = CURRENT_TIMESTAMP
    WHERE id = NEW.sport;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_sport_counts
AFTER INSERT OR UPDATE ON events
FOR EACH ROW
EXECUTE FUNCTION update_sport_counts();
```

### Auto-set updated_at timestamp

```sql
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_events_updated_at
BEFORE UPDATE ON events
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_streams_updated_at
BEFORE UPDATE ON streams
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();
```

---

## Query Examples

### Get all live events with their streams

```sql
SELECT 
    e.base_id,
    e.sport,
    e.title,
    e.start_time,
    e.logo_url,
    e.stream_count,
    json_agg(
        json_build_object(
            'id', s.id,
            'provider', s.provider_name,
            'language', s.language,
            'quality', s.quality,
            'stream_url', s.stream_url,
            'drm', CASE WHEN s.drm_type IS NOT NULL 
                   THEN json_build_object(
                       'type', s.drm_type,
                       'kid', s.drm_kid,
                       'key', s.drm_key
                   ) ELSE NULL END,
            'headers', s.headers
        ) ORDER BY s.sort_order
    ) AS streams
FROM events e
LEFT JOIN streams s ON e.base_id = s.event_id
WHERE e.is_live = TRUE
AND s.is_active = TRUE
GROUP BY e.base_id, e.sport, e.title, e.start_time, e.logo_url, e.stream_count;
```

### Get upcoming events by sport

```sql
SELECT 
    base_id,
    title,
    start_time,
    stream_count,
    logo_url
FROM events
WHERE sport = 'cricket'
AND timestamp > EXTRACT(EPOCH FROM NOW())
ORDER BY start_time ASC
LIMIT 10;
```

### Get event with alternative streams

```sql
SELECT 
    e.*,
    COUNT(s.id) as available_streams,
    array_agg(s.provider_name) as providers
FROM events e
LEFT JOIN streams s ON e.base_id = s.event_id AND s.is_active = TRUE
WHERE e.base_id = 'event-cricket-india-women-vs-zimbabwe-women-1792330200'
GROUP BY e.id;
```

### Get events grouped by sport with counts

```sql
SELECT 
    s.display_name,
    s.icon_url,
    COUNT(e.id) as total_events,
    COUNT(CASE WHEN e.is_live THEN 1 END) as live_events,
    COUNT(CASE WHEN e.is_trending THEN 1 END) as trending_events
FROM sports s
LEFT JOIN events e ON s.id = e.sport
WHERE s.is_active = TRUE
GROUP BY s.id, s.display_name, s.icon_url, s.sort_order
ORDER BY s.sort_order;
```

---

This comprehensive database schema provides:
- ✅ Full event and stream relationship modeling
- ✅ Efficient querying with proper indexes
- ✅ Automated statistics updates via triggers
- ✅ Support for live status, trending, and scheduling
- ✅ Multi-language and multi-provider stream management
- ✅ DRM configuration storage
- ✅ Analytics and performance tracking
- ✅ Scalable for thousands of events

Next sections will cover the API endpoints and data flow implementation.
