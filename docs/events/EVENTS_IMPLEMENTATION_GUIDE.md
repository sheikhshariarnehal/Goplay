# PlayzTV Events System - Implementation Guide for Testing App

## Overview

This guide provides step-by-step instructions for implementing the PlayzTV Events system in your testing application. It covers backend setup, API implementation, database integration, and client-side development.

---

## Table of Contents

1. [Project Setup](#1-project-setup)
2. [Database Setup](#2-database-setup)
3. [Backend API Implementation](#3-backend-api-implementation)
4. [Frontend/Mobile Client Implementation](#4-frontendmobile-client-implementation)
5. [Testing & Validation](#5-testing--validation)
6. [Deployment Checklist](#6-deployment-checklist)
7. [Troubleshooting Guide](#7-troubleshooting-guide)

---

## 1. Project Setup

### Technology Stack Recommendations

#### Backend Options

**Option A: Node.js + Express + PostgreSQL**
```
Recommended for: Fast development, JavaScript expertise
Stack:
- Node.js 18+ / TypeScript
- Express.js or Fastify
- PostgreSQL 14+
- Prisma ORM
- JWT for authentication
```

**Option B: Python + FastAPI + PostgreSQL**
```
Recommended for: Python expertise, async performance
Stack:
- Python 3.11+
- FastAPI
- PostgreSQL 14+
- SQLAlchemy ORM
- JWT for authentication
```

**Option C: Cloudflare Workers + D1**
```
Recommended for: Serverless, global edge deployment
Stack:
- Cloudflare Workers
- D1 (SQLite at edge)
- Hono framework
- JWT for authentication
```

#### Frontend/Mobile Options

**Android:**
- Kotlin + Jetpack Compose
- Retrofit for API calls
- ExoPlayer for video playback
- Room for local caching
- Hilt for dependency injection

**iOS:**
- Swift + SwiftUI
- URLSession + Combine for networking
- AVPlayer for video playback (HLS only)
- Core Data for caching
- SwiftUI for UI

**Web:**
- React or Vue.js
- Axios for API calls
- Shaka Player or Video.js for playback
- Redux/Vuex for state management

---

## 2. Database Setup

### PostgreSQL Setup

#### Install PostgreSQL (if not installed)

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

**macOS:**
```bash
brew install postgresql@14
brew services start postgresql@14
```

**Windows:**
Download from https://www.postgresql.org/download/windows/

#### Create Database and User

```sql
-- Connect to PostgreSQL
sudo -u postgres psql

-- Create database
CREATE DATABASE playztv_events;

-- Create user
CREATE USER playztv_admin WITH PASSWORD 'your_secure_password';

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE playztv_events TO playztv_admin;

-- Connect to database
\c playztv_events

-- Grant schema privileges
GRANT ALL ON SCHEMA public TO playztv_admin;

-- Exit
\q
```

#### Run Database Migrations

Create `migrations/001_create_tables.sql`:

```sql
-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create sports table
CREATE TABLE sports (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    display_name VARCHAR(100) NOT NULL,
    icon_url TEXT,
    description TEXT,
    event_count INT DEFAULT 0,
    live_count INT DEFAULT 0,
    trending_count INT DEFAULT 0,
    sort_order INT DEFAULT 0,
    color_hex VARCHAR(7),
    is_featured BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create events table
CREATE TABLE events (
    id VARCHAR(255) PRIMARY KEY,
    base_id VARCHAR(255) NOT NULL UNIQUE,
    sport VARCHAR(50) NOT NULL REFERENCES sports(id),
    team1 VARCHAR(255) NOT NULL,
    team2 VARCHAR(255) NOT NULL,
    title VARCHAR(500) GENERATED ALWAYS AS (team1 || ' vs ' || team2) STORED,
    timestamp BIGINT NOT NULL,
    start_time TIMESTAMP GENERATED ALWAYS AS (to_timestamp(timestamp)) STORED,
    duration_minutes INT DEFAULT 180,
    logo_url TEXT,
    tournament_id VARCHAR(50),
    tournament_name VARCHAR(255),
    is_live BOOLEAN DEFAULT FALSE,
    is_trending BOOLEAN DEFAULT FALSE,
    stream_count INT DEFAULT 0,
    view_count INT DEFAULT 0,
    region_restrictions JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_timestamp CHECK (timestamp > 0),
    CONSTRAINT chk_stream_count CHECK (stream_count >= 0)
);

-- Create streams table
CREATE TABLE streams (
    id VARCHAR(255) PRIMARY KEY,
    event_id VARCHAR(255) NOT NULL REFERENCES events(base_id) ON DELETE CASCADE,
    stream_number INT NOT NULL,
    provider_name VARCHAR(100),
    provider_region VARCHAR(10),
    language VARCHAR(50),
    name VARCHAR(500),
    quality VARCHAR(10) DEFAULT 'HD',
    stream_url TEXT NOT NULL,
    stream_type VARCHAR(10) NOT NULL,
    drm_type VARCHAR(20),
    drm_kid TEXT,
    drm_key TEXT,
    requires_headers BOOLEAN DEFAULT FALSE,
    headers JSON,
    requires_auth BOOLEAN DEFAULT FALSE,
    is_proxy BOOLEAN DEFAULT FALSE,
    cdn_provider VARCHAR(50),
    edge_location VARCHAR(50),
    sort_order INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    failure_count INT DEFAULT 0,
    last_verified TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(event_id, stream_number),
    CONSTRAINT chk_stream_number CHECK (stream_number > 0),
    CONSTRAINT chk_stream_type CHECK (stream_type IN ('hls', 'dash'))
);

-- Create providers table
CREATE TABLE providers (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    display_name VARCHAR(100) NOT NULL,
    logo_url TEXT,
    website_url TEXT,
    supports_drm BOOLEAN DEFAULT FALSE,
    drm_types JSON,
    stream_types JSON,
    primary_sports JSON,
    regions JSON,
    languages JSON,
    stream_count INT DEFAULT 0,
    active_stream_count INT DEFAULT 0,
    reliability_score DECIMAL(3,2) DEFAULT 0.00,
    is_active BOOLEAN DEFAULT TRUE,
    is_premium BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX idx_events_base_id ON events(base_id);
CREATE INDEX idx_events_sport ON events(sport);
CREATE INDEX idx_events_timestamp ON events(timestamp);
CREATE INDEX idx_events_start_time ON events(start_time);
CREATE INDEX idx_events_live ON events(is_live) WHERE is_live = TRUE;
CREATE INDEX idx_events_trending ON events(is_trending) WHERE is_trending = TRUE;
CREATE INDEX idx_events_upcoming ON events(timestamp) WHERE timestamp > EXTRACT(EPOCH FROM NOW());
CREATE INDEX idx_events_updated ON events(updated_at);

CREATE INDEX idx_streams_event ON streams(event_id);
CREATE INDEX idx_streams_provider ON streams(provider_name);
CREATE INDEX idx_streams_active ON streams(is_active) WHERE is_active = TRUE;
CREATE INDEX idx_streams_sort ON streams(event_id, sort_order);

CREATE INDEX idx_sports_sort ON sports(sort_order);
CREATE INDEX idx_sports_active ON sports(is_active) WHERE is_active = TRUE;

CREATE INDEX idx_providers_active ON providers(is_active) WHERE is_active = TRUE;

-- Full-text search
CREATE INDEX idx_events_search ON events USING gin(
    to_tsvector('english', team1 || ' ' || team2 || ' ' || COALESCE(tournament_name, ''))
);

-- Insert default sports
INSERT INTO sports (id, name, display_name, sort_order, color_hex) VALUES
('cricket', 'cricket', 'Cricket', 1, '#00A651'),
('football', 'football', 'Football', 2, '#00529B'),
('wwe', 'wwe', 'WWE/Wrestling', 3, '#C2161C'),
('boxing', 'boxing', 'Boxing', 4, '#FF6B35'),
('mixed-martial-arts', 'mixed-martial-arts', 'MMA/UFC', 5, '#D32F2F'),
('motorsport', 'motorsport', 'Motorsport', 6, '#E10600'),
('american-football', 'american-football', 'American Football', 7, '#013369'),
('hockey', 'hockey', 'Hockey', 8, '#000000'),
('baseball', 'baseball', 'Baseball', 9, '#E31837'),
('tennis', 'tennis', 'Tennis', 10, '#FFD700'),
('rugby', 'rugby', 'Rugby', 11, '#00843D');
```

Run migration:
```bash
psql -U playztv_admin -d playztv_events -f migrations/001_create_tables.sql
```

---

## 3. Backend API Implementation

### Node.js + Express Implementation

#### Project Structure

```
playztv-api/
├── src/
│   ├── config/
│   │   ├── database.js
│   │   └── env.js
│   ├── models/
│   │   ├── Event.js
│   │   ├── Stream.js
│   │   └── Sport.js
│   ├── routes/
│   │   ├── auth.js
│   │   ├── events.js
│   │   ├── sports.js
│   │   └── streams.js
│   ├── controllers/
│   │   ├── authController.js
│   │   ├── eventsController.js
│   │   └── sportsController.js
│   ├── middleware/
│   │   ├── auth.js
│   │   ├── validation.js
│   │   └── errorHandler.js
│   ├── services/
│   │   ├── eventService.js
│   │   └── streamService.js
│   └── app.js
├── migrations/
├── package.json
└── .env
```

#### Install Dependencies

```bash
npm init -y
npm install express pg dotenv cors helmet express-rate-limit
npm install jsonwebtoken bcrypt joi
npm install --save-dev nodemon
```

#### Configure Environment

Create `.env`:
```env
# Server
PORT=3000
NODE_ENV=development

# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=playztv_events
DB_USER=playztv_admin
DB_PASSWORD=your_secure_password

# JWT
JWT_SECRET=your_jwt_secret_key_change_this
JWT_EXPIRES_IN=1h

# CORS
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:8080

# Rate Limiting
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100
```

#### Database Connection

Create `src/config/database.js`:
```javascript
const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
});

pool.on('error', (err) => {
  console.error('Unexpected database error:', err);
  process.exit(-1);
});

module.exports = {
  query: (text, params) => pool.query(text, params),
  pool,
};
```

#### Authentication Middleware

Create `src/middleware/auth.js`:
```javascript
const jwt = require('jsonwebtoken');

const authMiddleware = (req, res, next) => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({
      success: false,
      error: {
        code: 'UNAUTHORIZED',
        message: 'No token provided'
      }
    });
  }

  const token = authHeader.substring(7);

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    next();
  } catch (error) {
    return res.status(401).json({
      success: false,
      error: {
        code: 'INVALID_TOKEN',
        message: 'Invalid or expired token'
      }
    });
  }
};

module.exports = authMiddleware;
```

#### Events Controller

Create `src/controllers/eventsController.js`:
```javascript
const db = require('../config/database');

class EventsController {
  // GET /api/v1/events
  async getEvents(req, res) {
    try {
      const {
        sport,
        live,
        trending,
        upcoming,
        limit = 50,
        offset = 0,
        sort = 'timestamp',
        order = 'asc'
      } = req.query;

      let whereClause = ['1=1'];
      let params = [];
      let paramIndex = 1;

      if (sport) {
        whereClause.push(`e.sport = $${paramIndex++}`);
        params.push(sport);
      }

      if (live === 'true') {
        whereClause.push(`e.is_live = true`);
      }

      if (trending === 'true') {
        whereClause.push(`e.is_trending = true`);
      }

      if (upcoming === 'true') {
        whereClause.push(`e.timestamp > EXTRACT(EPOCH FROM NOW())`);
      }

      const query = `
        SELECT 
          e.base_id as id,
          e.sport,
          e.title,
          json_build_object(
            'team1', e.team1,
            'team2', e.team2
          ) as participants,
          json_build_object(
            'timestamp', e.timestamp,
            'start_time', e.start_time,
            'duration_minutes', e.duration_minutes
          ) as schedule,
          json_build_object(
            'is_live', e.is_live,
            'is_trending', e.is_trending,
            'is_upcoming', (e.timestamp > EXTRACT(EPOCH FROM NOW()))
          ) as status,
          json_build_object(
            'id', e.tournament_id,
            'name', e.tournament_name
          ) as tournament,
          json_build_object(
            'logo', e.logo_url,
            'thumbnail', NULL
          ) as media,
          json_build_object(
            'total', e.stream_count,
            'available', (SELECT COUNT(*) FROM streams s WHERE s.event_id = e.base_id AND s.is_active = true)
          ) as streams,
          json_build_object(
            'view_count', e.view_count,
            'created_at', e.created_at,
            'updated_at', e.updated_at
          ) as meta
        FROM events e
        WHERE ${whereClause.join(' AND ')}
        ORDER BY e.${sort} ${order.toUpperCase()}
        LIMIT $${paramIndex++} OFFSET $${paramIndex}
      `;

      params.push(parseInt(limit), parseInt(offset));

      const result = await db.query(query, params);

      // Get total count
      const countQuery = `
        SELECT COUNT(*) as total
        FROM events e
        WHERE ${whereClause.join(' AND ')}
      `;
      const countResult = await db.query(countQuery, params.slice(0, -2));

      res.json({
        success: true,
        data: {
          events: result.rows,
          pagination: {
            total: parseInt(countResult.rows[0].total),
            count: result.rows.length,
            limit: parseInt(limit),
            offset: parseInt(offset),
            has_more: parseInt(offset) + result.rows.length < parseInt(countResult.rows[0].total)
          }
        },
        timestamp: new Date().toISOString()
      });
    } catch (error) {
      console.error('Error fetching events:', error);
      res.status(500).json({
        success: false,
        error: {
          code: 'INTERNAL_ERROR',
          message: 'Failed to fetch events'
        }
      });
    }
  }

  // GET /api/v1/events/:eventId
  async getEvent(req, res) {
    try {
      const { eventId } = req.params;

      const eventQuery = `
        SELECT 
          e.base_id as id,
          e.sport,
          e.title,
          json_build_object(
            'team1', e.team1,
            'team2', e.team2
          ) as participants,
          json_build_object(
            'timestamp', e.timestamp,
            'start_time', e.start_time,
            'duration_minutes', e.duration_minutes,
            'timezone', 'UTC'
          ) as schedule,
          json_build_object(
            'is_live', e.is_live,
            'is_trending', e.is_trending,
            'is_upcoming', (e.timestamp > EXTRACT(EPOCH FROM NOW())),
            'stream_status', 'ready'
          ) as status,
          json_build_object(
            'id', e.tournament_id,
            'name', e.tournament_name,
            'logo', e.logo_url
          ) as tournament,
          json_build_object(
            'logo', e.logo_url,
            'thumbnail', NULL
          ) as media,
          e.stream_count,
          json_build_object(
            'view_count', e.view_count,
            'created_at', e.created_at,
            'updated_at', e.updated_at
          ) as meta
        FROM events e
        WHERE e.base_id = $1
      `;

      const eventResult = await db.query(eventQuery, [eventId]);

      if (eventResult.rows.length === 0) {
        return res.status(404).json({
          success: false,
          error: {
            code: 'EVENT_NOT_FOUND',
            message: 'Event not found'
          }
        });
      }

      const event = eventResult.rows[0];

      // Fetch streams
      const streamsQuery = `
        SELECT 
          s.id,
          s.stream_number,
          json_build_object(
            'name', s.provider_name,
            'display_name', s.provider_name,
            'region', s.provider_region
          ) as provider,
          s.language,
          s.quality,
          s.stream_type,
          json_build_object(
            'provider', s.cdn_provider,
            'location', s.edge_location
          ) as cdn,
          json_build_object(
            'requires_auth', s.requires_auth,
            'requires_drm', (s.drm_type IS NOT NULL),
            'requires_headers', s.requires_headers,
            'geo_restricted', false
          ) as access,
          s.sort_order,
          s.is_active,
          COALESCE(0.95 - (s.failure_count * 0.05), 0.50) as reliability_score
        FROM streams s
        WHERE s.event_id = $1
        AND s.is_active = true
        ORDER BY s.sort_order
      `;

      const streamsResult = await db.query(streamsQuery, [eventId]);

      event.streams = streamsResult.rows;

      res.json({
        success: true,
        data: {
          event
        },
        timestamp: new Date().toISOString()
      });
    } catch (error) {
      console.error('Error fetching event:', error);
      res.status(500).json({
        success: false,
        error: {
          code: 'INTERNAL_ERROR',
          message: 'Failed to fetch event'
        }
      });
    }
  }

  // POST /api/v1/events/:eventId/access
  async getStreamAccess(req, res) {
    try {
      const { eventId } = req.params;
      const { stream_id, device_id, quality_preference, request_drm } = req.body;

      const streamQuery = `
        SELECT 
          s.*
        FROM streams s
        WHERE s.id = $1
        AND s.event_id = $2
        AND s.is_active = true
      `;

      const result = await db.query(streamQuery, [stream_id, eventId]);

      if (result.rows.length === 0) {
        return res.status(404).json({
          success: false,
          error: {
            code: 'STREAM_NOT_FOUND',
            message: 'Stream not found or inactive'
          }
        });
      }

      const stream = result.rows[0];

      // Build DRM object
      let drm = null;
      if (request_drm && stream.drm_type) {
        drm = {
          type: stream.drm_type,
          kid: stream.drm_kid,
          key: stream.drm_key
        };
      }

      // Generate session ID
      const sessionId = `play_${device_id.substring(0, 16)}`;
      const expiresAt = Math.floor(Date.now() / 1000) + 3600; // 1 hour

      res.json({
        success: true,
        data: {
          access: {
            stream_id: stream.id,
            stream_url: stream.stream_url,
            manifest_type: stream.stream_type,
            quality: stream.quality,
            headers: stream.headers || {},
            drm: drm,
            expires_at: expiresAt,
            expires_in: 3600
          },
          analytics: {
            session_id: sessionId,
            report_url: '/api/v1/analytics/playback'
          }
        },
        timestamp: new Date().toISOString()
      });
    } catch (error) {
      console.error('Error getting stream access:', error);
      res.status(500).json({
        success: false,
        error: {
          code: 'INTERNAL_ERROR',
          message: 'Failed to get stream access'
        }
      });
    }
  }
}

module.exports = new EventsController();
```

#### Routes Setup

Create `src/routes/events.js`:
```javascript
const express = require('express');
const router = express.Router();
const eventsController = require('../controllers/eventsController');
const authMiddleware = require('../middleware/auth');

router.get('/', authMiddleware, eventsController.getEvents);
router.get('/live', authMiddleware, eventsController.getEvents);
router.get('/trending', authMiddleware, eventsController.getEvents);
router.get('/:eventId', authMiddleware, eventsController.getEvent);
router.post('/:eventId/access', authMiddleware, eventsController.getStreamAccess);

module.exports = router;
```

#### Main App Setup

Create `src/app.js`:
```javascript
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
require('dotenv').config();

const authRoutes = require('./routes/auth');
const eventsRoutes = require('./routes/events');
const sportsRoutes = require('./routes/sports');

const app = express();

// Middleware
app.use(helmet());
app.use(cors({
  origin: process.env.ALLOWED_ORIGINS.split(','),
  credentials: true
}));
app.use(express.json());

// Rate limiting
const limiter = rateLimit({
  windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS),
  max: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS),
  message: {
    success: false,
    error: {
      code: 'RATE_LIMITED',
      message: 'Too many requests, please try again later'
    }
  }
});

app.use('/api', limiter);

// Routes
app.use('/api/v1/auth', authRoutes);
app.use('/api/v1/events', eventsRoutes);
app.use('/api/v1/sports', sportsRoutes);

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Error handler
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    success: false,
    error: {
      code: 'INTERNAL_ERROR',
      message: 'Something went wrong'
    }
  });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
  console.log(`📝 Environment: ${process.env.NODE_ENV}`);
});

module.exports = app;
```

#### Start the Server

```bash
npm run dev
```

---

## 4. Frontend/Mobile Client Implementation

### Android Kotlin Implementation

#### Project Structure

```
app/
├── src/main/java/com/yourapp/playztv/
│   ├── data/
│   │   ├── api/
│   │   │   ├── ApiService.kt
│   │   │   └── AuthInterceptor.kt
│   │   ├── models/
│   │   │   ├── Event.kt
│   │   │   ├── Stream.kt
│   │   │   └── ApiResponse.kt
│   │   └── repository/
│   │       └── EventRepository.kt
│   ├── ui/
│   │   ├── events/
│   │   │   ├── EventsViewModel.kt
│   │   │   ├── EventsScreen.kt
│   │   │   └── EventDetailScreen.kt
│   │   └── player/
│   │       ├── PlayerActivity.kt
│   │       └── PlayerViewModel.kt
│   └── utils/
│       ├── Constants.kt
│       └── DrmHelper.kt
```

#### Gradle Dependencies

Add to `build.gradle`:
```gradle
dependencies {
    // Networking
    implementation 'com.squareup.retrofit2:retrofit:2.9.0'
    implementation 'com.squareup.retrofit2:converter-gson:2.9.0'
    implementation 'com.squareup.okhttp3:okhttp:4.11.0'
    implementation 'com.squareup.okhttp3:logging-interceptor:4.11.0'
    
    // ExoPlayer
    implementation 'androidx.media3:media3-exoplayer:1.1.1'
    implementation 'androidx.media3:media3-exoplayer-dash:1.1.1'
    implementation 'androidx.media3:media3-exoplayer-hls:1.1.1'
    implementation 'androidx.media3:media3-ui:1.1.1'
    
    // Coroutines
    implementation 'org.jetbrains.kotlinx:kotlinx-coroutines-android:1.7.3'
    
    // ViewModel
    implementation 'androidx.lifecycle:lifecycle-viewmodel-ktx:2.6.2'
    implementation 'androidx.lifecycle:lifecycle-runtime-ktx:2.6.2'
    
    // Compose
    implementation 'androidx.compose.ui:ui:1.5.4'
    implementation 'androidx.compose.material3:material3:1.1.2'
    implementation 'androidx.compose.ui:ui-tooling-preview:1.5.4'
    
    // Coil for image loading
    implementation 'io.coil-kt:coil-compose:2.4.0'
}
```

#### API Models

Create `data/models/Event.kt`:
```kotlin
data class EventsResponse(
    val success: Boolean,
    val data: EventsData,
    val timestamp: String
)

data class EventsData(
    val events: List<Event>,
    val pagination: Pagination
)

data class Event(
    val id: String,
    val sport: String,
    val title: String,
    val participants: Participants,
    val schedule: Schedule,
    val status: EventStatus,
    val tournament: Tournament?,
    val media: Media,
    val streams: StreamsSummary,
    val meta: EventMeta
)

data class Participants(
    val team1: String,
    val team2: String
)

data class Schedule(
    val timestamp: Long,
    val start_time: String,
    val duration_minutes: Int
)

data class EventStatus(
    val is_live: Boolean,
    val is_trending: Boolean,
    val is_upcoming: Boolean
)

data class Tournament(
    val id: String,
    val name: String
)

data class Media(
    val logo: String?,
    val thumbnail: String?
)

data class StreamsSummary(
    val total: Int,
    val available: Int
)

data class EventMeta(
    val view_count: Int,
    val created_at: String,
    val updated_at: String
)

data class Pagination(
    val total: Int,
    val count: Int,
    val limit: Int,
    val offset: Int,
    val has_more: Boolean
)
```

Create `data/models/Stream.kt`:
```kotlin
data class StreamAccessResponse(
    val success: Boolean,
    val data: StreamAccessData
)

data class StreamAccessData(
    val access: StreamAccess,
    val analytics: Analytics
)

data class StreamAccess(
    val stream_id: String,
    val stream_url: String,
    val manifest_type: String,
    val quality: String,
    val headers: Map<String, String>,
    val drm: DrmConfig?,
    val expires_at: Long,
    val expires_in: Int
)

data class DrmConfig(
    val type: String,
    val kid: String,
    val key: String
)

data class Analytics(
    val session_id: String,
    val report_url: String
)
```

#### API Service

Create `data/api/ApiService.kt`:
```kotlin
interface ApiService {
    @GET("events")
    suspend fun getEvents(
        @Query("sport") sport: String? = null,
        @Query("live") live: Boolean? = null,
        @Query("trending") trending: Boolean? = null,
        @Query("limit") limit: Int = 50,
        @Query("offset") offset: Int = 0
    ): EventsResponse
    
    @GET("events/{eventId}")
    suspend fun getEvent(
        @Path("eventId") eventId: String
    ): EventDetailResponse
    
    @POST("events/{eventId}/access")
    suspend fun getStreamAccess(
        @Path("eventId") eventId: String,
        @Body request: StreamAccessRequest
    ): StreamAccessResponse
}

data class StreamAccessRequest(
    val stream_id: String,
    val device_id: String,
    val quality_preference: String = "HD",
    val request_drm: Boolean = true
)
```

#### Repository

Create `data/repository/EventRepository.kt`:
```kotlin
class EventRepository(
    private val apiService: ApiService
) {
    suspend fun getEvents(
        sport: String? = null,
        live: Boolean? = null
    ): Result<List<Event>> {
        return try {
            val response = apiService.getEvents(
                sport = sport,
                live = live
            )
            if (response.success) {
                Result.success(response.data.events)
            } else {
                Result.failure(Exception("Failed to fetch events"))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
    
    suspend fun getStreamAccess(
        eventId: String,
        streamId: String,
        deviceId: String
    ): Result<StreamAccess> {
        return try {
            val response = apiService.getStreamAccess(
                eventId = eventId,
                request = StreamAccessRequest(
                    stream_id = streamId,
                    device_id = deviceId
                )
            )
            if (response.success) {
                Result.success(response.data.access)
            } else {
                Result.failure(Exception("Failed to get stream access"))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
}
```

#### ExoPlayer Implementation

Create `ui/player/PlayerActivity.kt`:
```kotlin
class PlayerActivity : ComponentActivity() {
    private lateinit var player: ExoPlayer
    private val viewModel: PlayerViewModel by viewModels()
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        player = ExoPlayer.Builder(this).build()
        
        setContent {
            PlayerScreen(
                player = player,
                viewModel = viewModel
            )
        }
        
        // Get stream info from intent
        val streamId = intent.getStringExtra("STREAM_ID") ?: return
        val eventId = intent.getStringExtra("EVENT_ID") ?: return
        
        viewModel.loadStream(eventId, streamId)
    }
    
    override fun onDestroy() {
        super.onDestroy()
        player.release()
    }
}

@Composable
fun PlayerScreen(
    player: ExoPlayer,
    viewModel: PlayerViewModel
) {
    val streamAccess by viewModel.streamAccess.collectAsState()
    
    LaunchedEffect(streamAccess) {
        streamAccess?.let { access ->
            playStream(player, access)
        }
    }
    
    AndroidView(
        factory = { context ->
            PlayerView(context).apply {
                this.player = player
            }
        },
        modifier = Modifier.fillMaxSize()
    )
}

private fun playStream(player: ExoPlayer, access: StreamAccess) {
    val mediaItem = if (access.drm != null) {
        // DASH with ClearKey DRM
        MediaItem.Builder()
            .setUri(access.stream_url)
            .setDrmConfiguration(
                MediaItem.DrmConfiguration.Builder(C.CLEARKEY_UUID)
                    .setLicenseUri(buildClearKeyLicense(access.drm))
                    .build()
            )
            .build()
    } else {
        // HLS or unencrypted DASH
        MediaItem.fromUri(access.stream_url)
    }
    
    // Configure data source with headers
    val dataSourceFactory = DefaultHttpDataSource.Factory()
        .setUserAgent(access.headers["user-agent"] ?: "PlayzTV/1.0.0")
        .apply {
            access.headers["referer"]?.let {
                setDefaultRequestProperties(mapOf("Referer" to it))
            }
            access.headers["cookie"]?.let {
                setDefaultRequestProperties(mapOf("Cookie" to it))
            }
        }
    
    val mediaSource = when {
        access.stream_url.endsWith(".mpd") -> {
            DashMediaSource.Factory(dataSourceFactory)
                .createMediaSource(mediaItem)
        }
        access.stream_url.endsWith(".m3u8") -> {
            HlsMediaSource.Factory(dataSourceFactory)
                .createMediaSource(mediaItem)
        }
        else -> throw IllegalArgumentException("Unknown stream format")
    }
    
    player.setMediaSource(mediaSource)
    player.prepare()
    player.play()
}

private fun buildClearKeyLicense(drm: DrmConfig): String {
    val kidBase64 = drm.kid.hexToBase64()
    val keyBase64 = drm.key.hexToBase64()
    
    val json = """
    {
      "keys": [{
        "kty": "oct",
        "kid": "$kidBase64",
        "k": "$keyBase64"
      }],
      "type": "temporary"
    }
    """.trimIndent()
    
    return "data:application/json;base64,${json.toByteArray().toBase64()}"
}

fun String.hexToBase64(): String {
    val bytes = chunked(2).map { it.toInt(16).toByte() }.toByteArray()
    return android.util.Base64.encodeToString(
        bytes,
        android.util.Base64.URL_SAFE or android.util.Base64.NO_PADDING or android.util.Base64.NO_WRAP
    )
}

fun ByteArray.toBase64(): String {
    return android.util.Base64.encodeToString(
        this,
        android.util.Base64.NO_WRAP
    )
}
```

This implementation guide provides everything needed to build your testing app. Would you like me to continue with the iOS implementation, testing guide, and deployment checklist?
