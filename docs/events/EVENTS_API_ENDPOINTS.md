# PlayzTV Events API - Complete Endpoint Specification & Data Flow

## API Architecture Overview

The Events API is the central service that manages all sporting events, their associated streams, and real-time status updates. It provides a RESTful interface for fetching events, filtering by various criteria, and accessing stream alternatives.

### Base URL
```
https://playztv.pages.dev/api/v1/
```

### Authentication
All API requests require Bearer token authentication (obtained via `/auth/login`).

```http
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

---

## Complete API Endpoints

### 1. Events Endpoints

#### GET /events
Retrieve all events with optional filtering.

**Endpoint:**
```
GET /api/v1/events
```

**Query Parameters:**

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `sport` | string | No | null | Filter by sport ID (cricket, football, wwe, etc.) |
| `live` | boolean | No | null | Filter only live events (true/false) |
| `trending` | boolean | No | null | Filter trending events (true/false) |
| `upcoming` | boolean | No | null | Filter future events (true/false) |
| `date` | string | No | today | Filter by date (YYYY-MM-DD) |
| `hours` | integer | No | 24 | Look ahead hours (1-168) |
| `provider` | string | No | null | Filter by provider name |
| `language` | string | No | null | Filter by language code |
| `limit` | integer | No | 50 | Results per page (1-100) |
| `offset` | integer | No | 0 | Pagination offset |
| `sort` | string | No | timestamp | Sort by: timestamp, title, views |
| `order` | string | No | asc | Sort order: asc, desc |

**Request Example:**
```http
GET /api/v1/events?sport=cricket&live=true&limit=10 HTTP/1.1
Host: playztv.pages.dev
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Accept: application/json
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "events": [
      {
        "id": "event-cricket-india-women-vs-zimbabwe-women-1792330200",
        "sport": "cricket",
        "title": "India Women vs Zimbabwe Women",
        "participants": {
          "team1": "India Women",
          "team2": "Zimbabwe Women"
        },
        "schedule": {
          "timestamp": 1792330200,
          "start_time": "2026-10-25T08:30:00Z",
          "end_time": "2026-10-25T11:30:00Z",
          "duration_minutes": 180
        },
        "status": {
          "is_live": false,
          "is_trending": false,
          "is_upcoming": true
        },
        "tournament": {
          "id": "11222",
          "name": "Women's International Cricket"
        },
        "media": {
          "logo": "http://img.sofascore.com/api/v1/unique-tournament/11222/image/dark",
          "thumbnail": null
        },
        "streams": {
          "total": 9,
          "available": 9,
          "providers": ["WILLOW", "TNT SPORTS", "Star Sports", "FANCODE"]
        },
        "meta": {
          "view_count": 0,
          "created_at": "2026-10-20T10:30:00Z",
          "updated_at": "2026-10-25T07:00:00Z"
        }
      }
    ],
    "pagination": {
      "total": 79,
      "count": 10,
      "limit": 10,
      "offset": 0,
      "has_more": true
    }
  },
  "timestamp": "2026-10-25T14:09:53Z"
}
```

**Response Fields:**

- **id**: Event base ID (without stream suffix)
- **sport**: Sport category identifier
- **title**: Generated from participants
- **participants**: Team/participant objects
- **schedule**: Timing information with timestamps
- **status**: Live, trending, upcoming flags
- **tournament**: Tournament/competition details
- **media**: Logo and thumbnail URLs
- **streams**: Stream count and provider summary
- **meta**: Metadata including view counts

---

#### GET /events/{eventId}
Get detailed information about a specific event including all stream alternatives.

**Endpoint:**
```
GET /api/v1/events/{eventId}
```

**Path Parameters:**
- `eventId`: Event base ID (e.g., `event-cricket-india-women-vs-zimbabwe-women-1792330200`)

**Request Example:**
```http
GET /api/v1/events/event-cricket-india-women-vs-zimbabwe-women-1792330200 HTTP/1.1
Host: playztv.pages.dev
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "event": {
      "id": "event-cricket-india-women-vs-zimbabwe-women-1792330200",
      "sport": "cricket",
      "title": "India Women vs Zimbabwe Women",
      "participants": {
        "team1": "India Women",
        "team2": "Zimbabwe Women"
      },
      "schedule": {
        "timestamp": 1792330200,
        "start_time": "2026-10-25T08:30:00Z",
        "end_time": "2026-10-25T11:30:00Z",
        "duration_minutes": 180,
        "timezone": "UTC"
      },
      "status": {
        "is_live": false,
        "is_trending": false,
        "is_upcoming": true,
        "stream_status": "ready"
      },
      "tournament": {
        "id": "11222",
        "name": "Women's International Cricket",
        "season": "2026",
        "logo": "http://img.sofascore.com/api/v1/unique-tournament/11222/image/dark"
      },
      "media": {
        "logo": "http://img.sofascore.com/api/v1/unique-tournament/11222/image/dark",
        "thumbnail": null
      },
      "streams": [
        {
          "id": "event-cricket-india-women-vs-zimbabwe-women-1792330200-s1",
          "stream_number": 1,
          "provider": {
            "name": "WILLOW",
            "display_name": "WILLOW Cricket",
            "region": "AQ",
            "logo": "https://playztv.pages.dev/logos/willow.png"
          },
          "language": "EN",
          "quality": "HD",
          "stream_type": "dash",
          "cdn": {
            "provider": "amazon",
            "location": "iad-nitro"
          },
          "access": {
            "requires_auth": true,
            "requires_drm": true,
            "requires_headers": false,
            "geo_restricted": false
          },
          "sort_order": 0,
          "is_active": true,
          "reliability_score": 0.95
        },
        {
          "id": "event-cricket-india-women-vs-zimbabwe-women-1792330200-s2",
          "stream_number": 2,
          "provider": {
            "name": "TNT SPORTS",
            "display_name": "TNT Sports",
            "region": "AQ",
            "logo": "https://playztv.pages.dev/logos/tnt.png"
          },
          "language": "EN",
          "quality": "HD",
          "stream_type": "dash",
          "cdn": {
            "provider": "amazon",
            "location": "iad-nitro"
          },
          "access": {
            "requires_auth": true,
            "requires_drm": true,
            "requires_headers": false,
            "geo_restricted": false
          },
          "sort_order": 1,
          "is_active": true,
          "reliability_score": 0.92
        },
        {
          "id": "event-cricket-india-women-vs-zimbabwe-women-1792330200-s5",
          "stream_number": 5,
          "provider": {
            "name": "STAR SPORTS",
            "display_name": "Star Sports English",
            "region": "IN",
            "logo": "https://playztv.pages.dev/logos/star-sports.png"
          },
          "language": "EN",
          "quality": "HD",
          "stream_type": "dash",
          "cdn": {
            "provider": "hotstar",
            "location": "india"
          },
          "access": {
            "requires_auth": true,
            "requires_drm": true,
            "requires_headers": true,
            "geo_restricted": true,
            "allowed_regions": ["IN"]
          },
          "sort_order": 4,
          "is_active": true,
          "reliability_score": 0.98
        }
      ],
      "stream_summary": {
        "total": 9,
        "available": 9,
        "by_provider": {
          "WILLOW": 3,
          "TNT SPORTS": 1,
          "STAR SPORTS": 5
        },
        "by_language": {
          "EN": 4,
          "HINDI": 1,
          "TEL": 1,
          "TAM": 1,
          "KAN": 1,
          "MAR": 1
        },
        "by_quality": {
          "HD": 9,
          "FHD": 0,
          "SD": 0
        }
      },
      "recommendations": [
        "event-cricket-south-africa-vs-australia-1792308600",
        "event-cricket-wcl-vs-wcl-1792337400"
      ],
      "meta": {
        "view_count": 0,
        "created_at": "2026-10-20T10:30:00Z",
        "updated_at": "2026-10-25T07:00:00Z"
      }
    }
  },
  "timestamp": "2026-10-25T14:09:53Z"
}
```

---

#### POST /events/{eventId}/access
Request stream access token and URLs with DRM keys.

**Endpoint:**
```
POST /api/v1/events/{eventId}/access
```

**Request Body:**
```json
{
  "stream_id": "event-cricket-india-women-vs-zimbabwe-women-1792330200-s1",
  "device_id": "550e8400-e29b-41d4-a716-446655440000",
  "quality_preference": "HD",
  "request_drm": true
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "access": {
      "stream_id": "event-cricket-india-women-vs-zimbabwe-women-1792330200-s1",
      "stream_url": "https://otte.cache.aiv-cdn.net/iad-nitro/live/clients/dash/enc/oazcbevnl7/out/v1/bda05b242720469ca9fb9fabbde64cc2/cenc.mpd",
      "manifest_type": "dash",
      "quality": "HD",
      "headers": {},
      "drm": {
        "type": "clearkey",
        "license_url": "data:application/json;base64,...",
        "kid": "bfeaf0c7782327ca574f32b1629080b6",
        "key": "c03b21556a4cf97130228258de3fe45d"
      },
      "expires_at": 1729867793,
      "expires_in": 3600
    },
    "analytics": {
      "session_id": "play_550e8400e29b41d4a716",
      "report_url": "/api/v1/analytics/playback"
    },
    "alternatives": [
      {
        "stream_id": "event-cricket-india-women-vs-zimbabwe-women-1792330200-s2",
        "provider": "TNT SPORTS",
        "quality": "HD"
      },
      {
        "stream_id": "event-cricket-india-women-vs-zimbabwe-women-1792330200-s3",
        "provider": "WILLOW S2",
        "quality": "HD"
      }
    ]
  },
  "timestamp": "2026-10-25T14:09:53Z"
}
```

---

#### GET /events/live
Quick endpoint for live events only.

**Endpoint:**
```
GET /api/v1/events/live
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "live_events": [
      {
        "id": "event-boxing-bkfc-vs-bkfc-1792281600",
        "sport": "boxing",
        "title": "BKFC Live Event",
        "start_time": "2026-10-25T14:00:00Z",
        "logo": "https://...",
        "stream_count": 3,
        "top_stream": {
          "id": "event-boxing-bkfc-vs-bkfc-1792281600-s1",
          "provider": "PLAYZTV FHD"
        }
      }
    ],
    "total": 6
  }
}
```

---

#### GET /events/trending
Get trending/featured events.

**Endpoint:**
```
GET /api/v1/events/trending
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "trending_events": [
      {
        "id": "event-football-fc-barcelona-vs-real-madrid-1792958400",
        "sport": "football",
        "title": "FC Barcelona vs Real Madrid",
        "start_time": "2026-10-27T19:00:00Z",
        "logo": "https://...",
        "stream_count": 5,
        "trending_score": 0.98
      }
    ],
    "total": 2
  }
}
```

---

#### GET /events/upcoming
Get upcoming events in next N hours.

**Endpoint:**
```
GET /api/v1/events/upcoming?hours=24
```

**Response:** Similar to `/events` with upcoming filter applied.

---

### 2. Sports Endpoints

#### GET /sports
List all available sports with statistics.

**Endpoint:**
```
GET /api/v1/sports
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "sports": [
      {
        "id": "cricket",
        "name": "Cricket",
        "icon": "https://playztv.pages.dev/icons/cricket.png",
        "color": "#00A651",
        "statistics": {
          "total_events": 60,
          "live_events": 3,
          "trending_events": 1,
          "upcoming_events": 45
        },
        "top_providers": ["WILLOW", "FANCODE", "Star Sports"],
        "sort_order": 1
      },
      {
        "id": "football",
        "name": "Football",
        "icon": "https://playztv.pages.dev/icons/football.png",
        "color": "#00529B",
        "statistics": {
          "total_events": 26,
          "live_events": 2,
          "trending_events": 1,
          "upcoming_events": 20
        },
        "top_providers": ["DAZN", "SKY SPORTS", "BEIN SPORTS"],
        "sort_order": 2
      }
    ],
    "total": 11
  }
}
```

---

#### GET /sports/{sportId}/events
Get all events for a specific sport.

**Endpoint:**
```
GET /api/v1/sports/cricket/events
```

**Response:** Similar to `/events?sport=cricket`

---

### 3. Stream Endpoints

#### GET /streams/{streamId}
Get detailed stream information including access credentials.

**Endpoint:**
```
GET /api/v1/streams/{streamId}
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "stream": {
      "id": "event-cricket-india-women-vs-zimbabwe-women-1792330200-s1",
      "event_id": "event-cricket-india-women-vs-zimbabwe-women-1792330200",
      "stream_number": 1,
      "provider": {
        "name": "WILLOW",
        "display_name": "WILLOW Cricket",
        "region": "AQ"
      },
      "quality": "HD",
      "stream_url": "https://otte.cache.aiv-cdn.net/...",
      "stream_type": "dash",
      "drm": {
        "type": "clearkey",
        "kid": "bfeaf0c7782327ca574f32b1629080b6",
        "key": "c03b21556a4cf97130228258de3fe45d"
      },
      "headers": {},
      "cdn": {
        "provider": "amazon",
        "location": "iad-nitro",
        "edge_servers": ["server1.aiv-cdn.net", "server2.aiv-cdn.net"]
      },
      "performance": {
        "reliability_score": 0.95,
        "avg_bitrate_kbps": 5000,
        "avg_buffer_time_ms": 800,
        "success_rate": 0.95
      },
      "is_active": true
    }
  }
}
```

---

### 4. Provider Endpoints

#### GET /providers
List all content providers.

**Endpoint:**
```
GET /api/v1/providers
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "providers": [
      {
        "id": "willow",
        "name": "WILLOW",
        "display_name": "WILLOW Cricket",
        "logo": "https://playztv.pages.dev/logos/willow.png",
        "website": "https://www.willow.tv",
        "capabilities": {
          "supports_drm": true,
          "drm_types": ["clearkey"],
          "stream_types": ["dash", "hls"],
          "max_quality": "HD"
        },
        "coverage": {
          "sports": ["cricket"],
          "regions": ["AQ", "US", "CA"],
          "languages": ["EN"]
        },
        "statistics": {
          "stream_count": 15,
          "active_streams": 12,
          "reliability_score": 0.95
        },
        "is_premium": true
      }
    ],
    "total": 30
  }
}
```

---

#### GET /providers/{providerId}/streams
Get all streams from a specific provider.

**Endpoint:**
```
GET /api/v1/providers/willow/streams
```

---

### 5. Schedule Endpoints

#### GET /schedule
Get event schedule for date range.

**Endpoint:**
```
GET /api/v1/schedule?date=2026-10-25&days=7
```

**Query Parameters:**
- `date`: Start date (YYYY-MM-DD)
- `days`: Number of days to fetch (1-30)
- `sport`: Filter by sport
- `timezone`: Client timezone (default: UTC)

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "schedule": {
      "2026-10-25": [
        {
          "id": "event-cricket-india-women-vs-zimbabwe-women-1792330200",
          "sport": "cricket",
          "title": "India Women vs Zimbabwe Women",
          "start_time": "08:30:00",
          "timezone": "UTC",
          "is_live": false,
          "stream_count": 9
        }
      ],
      "2026-10-26": [
        {
          "id": "event-wwe-wwe-raw-vs-wwe-raw-1792454400",
          "sport": "wwe",
          "title": "WWE RAW",
          "start_time": "20:00:00",
          "timezone": "UTC",
          "is_live": false,
          "stream_count": 6
        }
      ]
    },
    "date_range": {
      "start": "2026-10-25",
      "end": "2026-10-31"
    }
  }
}
```

---

### 6. Search Endpoint

#### GET /search
Search events by keyword.

**Endpoint:**
```
GET /api/v1/search?q=india+cricket&limit=20
```

**Query Parameters:**
- `q`: Search query (team names, tournament, etc.)
- `sport`: Filter by sport
- `live`: Only live events
- `limit`: Results limit (default: 20)

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "results": [
      {
        "id": "event-cricket-india-women-vs-zimbabwe-women-1792330200",
        "sport": "cricket",
        "title": "India Women vs Zimbabwe Women",
        "match_score": 0.95,
        "matched_fields": ["team1", "sport"],
        "start_time": "2026-10-25T08:30:00Z",
        "stream_count": 9
      }
    ],
    "total": 15,
    "query": "india cricket"
  }
}
```

---

### 7. Analytics Endpoints

#### POST /analytics/playback
Report playback event.

**Endpoint:**
```
POST /api/v1/analytics/playback
```

**Request Body:**
```json
{
  "session_id": "play_550e8400e29b41d4a716",
  "event_id": "event-cricket-india-women-vs-zimbabwe-women-1792330200",
  "stream_id": "event-cricket-india-women-vs-zimbabwe-women-1792330200-s1",
  "event_type": "playback_start",
  "timestamp": 1729864193,
  "metrics": {
    "buffer_time_ms": 1200,
    "start_time_ms": 2500,
    "quality": "1080p",
    "bitrate_kbps": 5000
  },
  "device": {
    "device_id": "550e8400-e29b-41d4-a716-446655440000",
    "platform": "android",
    "os_version": "13",
    "app_version": "1.0.0"
  }
}
```

**Event Types:**
- `playback_start`
- `playback_pause`
- `playback_resume`
- `playback_stop`
- `playback_complete`
- `playback_error`
- `playback_buffer`
- `quality_change`

**Response (200 OK):**
```json
{
  "success": true,
  "recorded": true
}
```

---

#### POST /analytics/error
Report stream error.

**Request Body:**
```json
{
  "event_id": "event-cricket-india-women-vs-zimbabwe-women-1792330200",
  "stream_id": "event-cricket-india-women-vs-zimbabwe-women-1792330200-s1",
  "error_code": "DRM_LICENSE_ERROR",
  "error_message": "Failed to acquire ClearKey license",
  "timestamp": 1729864193,
  "context": {
    "player_state": "loading",
    "network_type": "wifi",
    "connection_speed_mbps": 50
  }
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "recorded": true,
  "suggested_action": {
    "action": "retry_alternative",
    "alternative_stream": {
      "id": "event-cricket-india-women-vs-zimbabwe-women-1792330200-s2",
      "provider": "TNT SPORTS",
      "reason": "Different CDN and DRM configuration"
    }
  }
}
```

---

## Complete Data Flow Architecture

### 1. App Launch → Event List Flow

```
┌──────────────────────────────────────────────────────────────┐
│                    USER OPENS APP                             │
└──────────────────────┬───────────────────────────────────────┘
                       │
                       ▼
┌──────────────────────────────────────────────────────────────┐
│              AUTHENTICATION FLOW                              │
│                                                               │
│  1. Check stored token                                        │
│     ├─ Valid? → Use existing token                           │
│     └─ Invalid/Missing? → POST /auth/login                   │
│                                                               │
│  POST /api/v1/auth/login                                     │
│  {                                                            │
│    "device_id": "uuid",                                       │
│    "device_type": "android"                                   │
│  }                                                            │
│                                                               │
│  Response:                                                    │
│  {                                                            │
│    "token": "jwt_token",                                      │
│    "expires_in": 1800                                         │
│  }                                                            │
│                                                               │
│  2. Store token securely (KeyStore/Keychain)                 │
│  3. Set token in API client headers                          │
└──────────────────────┬───────────────────────────────────────┘
                       │
                       ▼
┌──────────────────────────────────────────────────────────────┐
│              FETCH INITIAL DATA                               │
│                                                               │
│  Parallel Requests:                                           │
│                                                               │
│  1. GET /api/v1/sports                                        │
│     → Get sports categories with counts                       │
│                                                               │
│  2. GET /api/v1/events?live=true                             │
│     → Get currently live events                               │
│                                                               │
│  3. GET /api/v1/events?trending=true                         │
│     → Get featured events                                     │
│                                                               │
│  4. GET /api/v1/events?upcoming=true&hours=24                │
│     → Get upcoming events in next 24 hours                    │
└──────────────────────┬───────────────────────────────────────┘
                       │
                       ▼
┌──────────────────────────────────────────────────────────────┐
│              PROCESS & DISPLAY                                │
│                                                               │
│  1. Parse API responses                                       │
│  2. Store in local cache/state management                     │
│  3. Build UI sections:                                        │
│     ├─ Live Events (carousel/grid)                           │
│     ├─ Trending Events (featured section)                    │
│     ├─ Sports Categories (tabs/chips)                        │
│     └─ Upcoming Events (list/schedule)                       │
│                                                               │
│  4. Setup periodic refresh (every 30 seconds for live)        │
└───────────────────────────────────────────────────────────────┘
```

---

### 2. User Selects Sport → Filtered Events Flow

```
┌──────────────────────────────────────────────────────────────┐
│              USER TAPS "CRICKET" CATEGORY                     │
└──────────────────────┬───────────────────────────────────────┘
                       │
                       ▼
┌──────────────────────────────────────────────────────────────┐
│              API REQUEST                                      │
│                                                               │
│  GET /api/v1/events?sport=cricket&limit=50                   │
│  Authorization: Bearer {token}                                │
└──────────────────────┬───────────────────────────────────────┘
                       │
                       ▼
┌──────────────────────────────────────────────────────────────┐
│              BACKEND PROCESSING                               │
│                                                               │
│  1. Validate auth token                                       │
│  2. Query database:                                           │
│                                                               │
│     SELECT e.*, COUNT(s.id) as stream_count                  │
│     FROM events e                                             │
│     LEFT JOIN streams s ON e.base_id = s.event_id            │
│     WHERE e.sport = 'cricket'                                 │
│     AND s.is_active = TRUE                                    │
│     GROUP BY e.id                                             │
│     ORDER BY e.timestamp ASC                                  │
│     LIMIT 50                                                  │
│                                                               │
│  3. Transform to API response format                          │
│  4. Return JSON                                               │
└──────────────────────┬───────────────────────────────────────┘
                       │
                       ▼
┌──────────────────────────────────────────────────────────────┐
│              DISPLAY FILTERED LIST                            │
│                                                               │
│  1. Update UI with cricket events only                        │
│  2. Show event cards with:                                    │
│     - Teams/participants                                      │
│     - Start time                                              │
│     - Stream count                                            │
│     - Live indicator (if live)                                │
│     - Trending badge (if trending)                            │
└───────────────────────────────────────────────────────────────┘
```

---

### 3. User Selects Event → Stream Selection Flow

```
┌──────────────────────────────────────────────────────────────┐
│       USER TAPS EVENT: "India Women vs Zimbabwe Women"        │
└──────────────────────┬───────────────────────────────────────┘
                       │
                       ▼
┌──────────────────────────────────────────────────────────────┐
│              FETCH EVENT DETAILS                              │
│                                                               │
│  GET /api/v1/events/event-cricket-india-women-vs-...-1792... │
│  Authorization: Bearer {token}                                │
└──────────────────────┬───────────────────────────────────────┘
                       │
                       ▼
┌──────────────────────────────────────────────────────────────┐
│              BACKEND PROCESSING                               │
│                                                               │
│  1. Validate token                                            │
│  2. Query event with all streams:                             │
│                                                               │
│     SELECT e.*, json_agg(s.*) as streams                     │
│     FROM events e                                             │
│     LEFT JOIN streams s ON e.base_id = s.event_id            │
│     WHERE e.base_id = '{eventId}'                            │
│     AND s.is_active = TRUE                                    │
│     GROUP BY e.id                                             │
│                                                               │
│  3. Include stream metadata:                                  │
│     - Provider details                                        │
│     - Language options                                        │
│     - Quality levels                                          │
│     - DRM requirements                                        │
│     - Reliability scores                                      │
│                                                               │
│  4. Return complete event object with all streams             │
└──────────────────────┬───────────────────────────────────────┘
                       │
                       ▼
┌──────────────────────────────────────────────────────────────┐
│              DISPLAY EVENT DETAILS                            │
│                                                               │
│  Show Event Info Screen:                                      │
│  ┌────────────────────────────────────────────────────────┐  │
│  │  [Event Logo/Banner]                                    │  │
│  │                                                          │  │
│  │  India Women vs Zimbabwe Women                          │  │
│  │  Women's International Cricket                          │  │
│  │  📅 Oct 25, 2026 • 08:30 UTC                           │  │
│  │  ⏱ Duration: ~3 hours                                   │  │
│  │                                                          │  │
│  │  Available Streams (9):                                 │  │
│  │  ┌──────────────────────────────────────────────────┐  │  │
│  │  │ 🏏 WILLOW - AQ          [HD] [DRM]   ⭐ 95%     │  │  │
│  │  │ 📺 TNT SPORTS - AQ       [HD] [DRM]   ⭐ 92%     │  │  │
│  │  │ 🌟 Star Sports EN - IN   [HD] [DRM]   ⭐ 98%     │  │  │
│  │  │ 📡 Star Sports HI - IN   [HD] [DRM]   ⭐ 98%     │  │  │
│  │  │ ... +5 more streams                               │  │  │
│  │  └──────────────────────────────────────────────────┘  │  │
│  │                                                          │  │
│  │  [WATCH NOW] [ADD TO CALENDAR] [SHARE]                 │  │
│  └────────────────────────────────────────────────────────┘  │
└──────────────────────┬───────────────────────────────────────┘
                       │
                       ▼
┌──────────────────────────────────────────────────────────────┐
│       USER SELECTS STREAM: "WILLOW - AQ"                     │
└───────────────────────────────────────────────────────────────┘
```

---

### 4. Stream Playback → Video Player Flow

```
┌──────────────────────────────────────────────────────────────┐
│       USER TAPS "WATCH NOW" ON WILLOW STREAM                 │
└──────────────────────┬───────────────────────────────────────┘
                       │
                       ▼
┌──────────────────────────────────────────────────────────────┐
│              REQUEST STREAM ACCESS                            │
│                                                               │
│  POST /api/v1/events/{eventId}/access                        │
│  {                                                            │
│    "stream_id": "event-cricket-...-s1",                      │
│    "device_id": "550e8400-...",                              │
│    "quality_preference": "HD",                                │
│    "request_drm": true                                        │
│  }                                                            │
└──────────────────────┬───────────────────────────────────────┘
                       │
                       ▼
┌──────────────────────────────────────────────────────────────┐
│              BACKEND: GENERATE ACCESS TOKEN                   │
│                                                               │
│  1. Validate user token & device                             │
│  2. Check entitlements (if subscription-based)               │
│  3. Fetch stream details from database                       │
│  4. Generate time-limited access token (1 hour)              │
│  5. Prepare DRM keys                                         │
│  6. Log access request for analytics                         │
│  7. Return stream access object                              │
└──────────────────────┬───────────────────────────────────────┘
                       │
                       ▼
┌──────────────────────────────────────────────────────────────┐
│              RESPONSE WITH STREAM DATA                        │
│                                                               │
│  {                                                            │
│    "stream_url": "https://otte.cache.aiv-cdn.net/...mpd",   │
│    "manifest_type": "dash",                                   │
│    "headers": {},                                             │
│    "drm": {                                                   │
│      "type": "clearkey",                                      │
│      "kid": "bfeaf0c...",                                     │
│      "key": "c03b21..."                                       │
│    },                                                         │
│    "expires_at": 1729867793,                                  │
│    "analytics": {                                             │
│      "session_id": "play_550e8400..."                        │
│    },                                                         │
│    "alternatives": [...]                                      │
│  }                                                            │
└──────────────────────┬───────────────────────────────────────┘
                       │
                       ▼
┌──────────────────────────────────────────────────────────────┐
│              INITIALIZE VIDEO PLAYER                          │
│                                                               │
│  1. Create ExoPlayer instance (Android) / AVPlayer (iOS)     │
│  2. Configure DRM:                                            │
│     - Set ClearKey license with KID & Key                    │
│     - Convert hex keys to base64                             │
│     - Build license JSON                                      │
│                                                               │
│  3. Configure network:                                        │
│     - Set custom headers (if required)                       │
│     - Set user-agent                                          │
│     - Configure timeouts                                      │
│                                                               │
│  4. Load manifest URL:                                        │
│     player.setMediaSource(                                    │
│       DashMediaSource.Factory(dataSourceFactory)             │
│         .createMediaSource(mediaItem)                         │
│     )                                                         │
│                                                               │
│  5. Prepare and start playback                               │
└──────────────────────┬───────────────────────────────────────┘
                       │
                       ▼
┌──────────────────────────────────────────────────────────────┐
│              PLAYBACK STARTS                                  │
│                                                               │
│  Player fetches:                                              │
│  1. Manifest (.mpd) → Parse available qualities              │
│  2. Init segments → Initialize codecs                        │
│  3. Media segments → Start playback                          │
│  4. DRM license → Decrypt segments (if DRM)                  │
│                                                               │
│  Report to analytics:                                         │
│  POST /api/v1/analytics/playback                             │
│  {                                                            │
│    "event_type": "playback_start",                           │
│    "metrics": {                                               │
│      "buffer_time_ms": 1200,                                  │
│      "start_time_ms": 2500                                    │
│    }                                                          │
│  }                                                            │
└──────────────────────┬───────────────────────────────────────┘
                       │
                       ▼
┌──────────────────────────────────────────────────────────────┐
│              USER WATCHES STREAM                              │
│                                                               │
│  Player UI showing:                                           │
│  - Video playback                                             │
│  - Play/Pause controls                                        │
│  - Quality selector (if ABR)                                  │
│  - Live indicator                                             │
│  - Stream info (provider, language)                          │
│  - Alternative streams button                                 │
│                                                               │
│  Continuous monitoring:                                       │
│  - Buffer health                                              │
│  - Network quality                                            │
│  - Playback errors                                            │
│  - Quality changes                                            │
│                                                               │
│  Report events:                                               │
│  - Buffering events                                           │
│  - Quality changes                                            │
│  - Errors (with retry/fallback logic)                        │
└───────────────────────────────────────────────────────────────┘
```

---

### 5. Error Handling & Fallback Flow

```
┌──────────────────────────────────────────────────────────────┐
│              PLAYBACK ERROR OCCURS                            │
│              (DRM failure, 404, timeout, etc.)                │
└──────────────────────┬───────────────────────────────────────┘
                       │
                       ▼
┌──────────────────────────────────────────────────────────────┐
│              LOG ERROR                                        │
│                                                               │
│  POST /api/v1/analytics/error                                │
│  {                                                            │
│    "event_id": "...",                                         │
│    "stream_id": "...-s1",                                     │
│    "error_code": "DRM_LICENSE_ERROR",                        │
│    "error_message": "Failed to acquire license",             │
│    "context": {...}                                           │
│  }                                                            │
└──────────────────────┬───────────────────────────────────────┘
                       │
                       ▼
┌──────────────────────────────────────────────────────────────┐
│              BACKEND: SUGGEST ALTERNATIVE                     │
│                                                               │
│  Response:                                                    │
│  {                                                            │
│    "recorded": true,                                          │
│    "suggested_action": {                                      │
│      "action": "retry_alternative",                          │
│      "alternative_stream": {                                  │
│        "id": "...-s2",                                        │
│        "provider": "TNT SPORTS",                              │
│        "reason": "Different CDN, different DRM"              │
│      }                                                        │
│    }                                                          │
│  }                                                            │
└──────────────────────┬───────────────────────────────────────┘
                       │
                       ▼
┌──────────────────────────────────────────────────────────────┐
│              APP: TRY ALTERNATIVE STREAM                      │
│                                                               │
│  1. Show user notification:                                   │
│     "Stream failed. Trying alternative source..."            │
│                                                               │
│  2. Fetch alternative stream access:                          │
│     POST /api/v1/events/{eventId}/access                     │
│     { "stream_id": "...-s2" }                                │
│                                                               │
│  3. Reinitialize player with new stream                      │
│  4. Resume playback                                           │
│                                                               │
│  Fallback sequence:                                           │
│  s1 → s2 → s3 → ... → sN                                     │
│                                                               │
│  If all streams fail:                                         │
│  - Show error message                                         │
│  - Offer manual stream selection                             │
│  - Suggest checking network                                   │
└───────────────────────────────────────────────────────────────┘
```

---

### 6. Live Status Updates Flow

```
┌──────────────────────────────────────────────────────────────┐
│              BACKGROUND SERVICE / WEBSOCKET                   │
│                                                               │
│  Option A: Polling (every 30 seconds)                        │
│  ┌────────────────────────────────────────────────────────┐  │
│  │  setInterval(() => {                                    │  │
│  │    GET /api/v1/events/live                             │  │
│  │    // Update local state if changes detected           │  │
│  │  }, 30000)                                              │  │
│  └────────────────────────────────────────────────────────┘  │
│                                                               │
│  Option B: WebSocket (real-time)                             │
│  ┌────────────────────────────────────────────────────────┐  │
│  │  wss://playztv.pages.dev/ws                            │  │
│  │                                                          │  │
│  │  Server pushes updates:                                 │  │
│  │  {                                                       │  │
│  │    "type": "event_status_update",                       │  │
│  │    "event_id": "...",                                    │  │
│  │    "is_live": true,                                      │  │
│  │    "timestamp": 1729864193                               │  │
│  │  }                                                       │  │
│  └────────────────────────────────────────────────────────┘  │
│                                                               │
│  On update received:                                          │
│  1. Update local event state                                 │
│  2. Show live badge/indicator                                │
│  3. Notify user if event just went live                      │
│  4. Update stream availability                               │
└───────────────────────────────────────────────────────────────┘
```

---

This completes the comprehensive Events API endpoint specification and data flow documentation. Next, I'll create the GLOSSARY and implementation guide for developers.
