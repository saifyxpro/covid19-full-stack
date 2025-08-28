# 🌐 API Documentation

## Overview

The COVID-19 Full Stack Application provides a RESTful API for accessing COVID-19 statistics, country information, and map data. This API serves real-time data for global COVID-19 tracking and visualization.

**Base URL:** `https://your-api-domain.com/api` (or `http://localhost:5000/api` for development)

**Version:** 2.0.0  
**Author:** Saify (@saifyxpro)  
**Repository:** [saifyxpro/covid19-full-stack](https://github.com/saifyxpro/covid19-full-stack)

---

## 🔑 Authentication

Currently, the API is open and doesn't require authentication. Rate limiting is applied:

- **Rate Limit:** 100 requests per 15 minutes per IP
- **Headers:** Rate limit information is included in response headers

```http
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 99
X-RateLimit-Reset: 1640995200
```

---

## 📊 Endpoints

### 🏥 Statistics Endpoints

#### Get Global Statistics
Retrieve global COVID-19 statistics summary.

```http
GET /api/statistics/global
```

**Response:**
```json
{
  "success": true,
  "data": {
    "cases": 650000000,
    "deaths": 6700000,
    "recovered": 625000000,
    "active": 18300000,
    "critical": 45000,
    "todayCases": 15000,
    "todayDeaths": 300,
    "todayRecovered": 25000,
    "updated": 1640995200000,
    "casesPerOneMillion": 83000,
    "deathsPerOneMillion": 860,
    "tests": 8500000000,
    "testsPerOneMillion": 1100000
  },
  "timestamp": "2023-12-15T10:30:00Z",
  "cached": true,
  "cacheExpiry": "2023-12-15T11:00:00Z"
}
```

#### Get Statistics by Country
Retrieve COVID-19 statistics for a specific country.

```http
GET /api/statistics/country/:country
```

**Parameters:**
- `country` (string): Country name, ISO2, or ISO3 code

**Example:**
```http
GET /api/statistics/country/USA
GET /api/statistics/country/United States
```

**Response:**
```json
{
  "success": true,
  "data": {
    "country": "USA",
    "countryInfo": {
      "_id": 840,
      "iso2": "US",
      "iso3": "USA",
      "lat": 38,
      "long": -97,
      "flag": "https://disease.sh/assets/img/flags/us.png"
    },
    "cases": 100000000,
    "deaths": 1100000,
    "recovered": 97000000,
    "active": 1900000,
    "critical": 5000,
    "todayCases": 2500,
    "todayDeaths": 50,
    "todayRecovered": 3000,
    "updated": 1640995200000,
    "population": 331000000,
    "casesPerOneMillion": 302000,
    "deathsPerOneMillion": 3300,
    "tests": 900000000,
    "testsPerOneMillion": 2700000
  },
  "timestamp": "2023-12-15T10:30:00Z"
}
```

#### Get All Countries Statistics
Retrieve COVID-19 statistics for all countries.

```http
GET /api/statistics/countries
```

**Query Parameters:**
- `sort` (string, optional): Field to sort by (cases, deaths, recovered, etc.)
- `limit` (number, optional): Number of countries to return (default: all)

**Example:**
```http
GET /api/statistics/countries?sort=cases&limit=10
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "country": "USA",
      "cases": 100000000,
      "deaths": 1100000,
      // ... full country statistics
    },
    // ... more countries
  ],
  "total": 195,
  "timestamp": "2023-12-15T10:30:00Z"
}
```

### 🌍 Country Information Endpoints

#### Get All Countries
Retrieve list of all countries with basic information.

```http
GET /api/countries
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "name": "United States",
      "iso2": "US",
      "iso3": "USA",
      "coordinates": {
        "latitude": 38,
        "longitude": -97
      },
      "flag": "https://disease.sh/assets/img/flags/us.png",
      "population": 331000000
    },
    // ... more countries
  ],
  "total": 195,
  "timestamp": "2023-12-15T10:30:00Z"
}
```

#### Get Country Information
Retrieve detailed information for a specific country.

```http
GET /api/countries/:country
```

**Parameters:**
- `country` (string): Country name, ISO2, or ISO3 code

**Response:**
```json
{
  "success": true,
  "data": {
    "name": "United States",
    "iso2": "US",
    "iso3": "USA",
    "coordinates": {
      "latitude": 38,
      "longitude": -97
    },
    "flag": "https://disease.sh/assets/img/flags/us.png",
    "population": 331000000,
    "continent": "North America",
    "area": 9833517,
    "currency": "USD",
    "languages": ["English"],
    "timezone": "UTC-5 to UTC-10"
  },
  "timestamp": "2023-12-15T10:30:00Z"
}
```

### 🗺️ Map Data Endpoints

#### Get Map Markers
Retrieve marker data for map visualization.

```http
GET /api/map/markers
```

**Query Parameters:**
- `threshold` (number, optional): Minimum case count for marker inclusion
- `type` (string, optional): Data type (cases, deaths, recovered)

**Example:**
```http
GET /api/map/markers?threshold=10000&type=cases
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "US",
      "country": "United States",
      "coordinates": {
        "latitude": 38,
        "longitude": -97
      },
      "cases": 100000000,
      "deaths": 1100000,
      "recovered": 97000000,
      "markerSize": 50,
      "color": "#ff4444"
    },
    // ... more markers
  ],
  "total": 150,
  "timestamp": "2023-12-15T10:30:00Z"
}
```

### 📈 Historical Data Endpoints

#### Get Historical Global Data
Retrieve historical global statistics.

```http
GET /api/historical/global
```

**Query Parameters:**
- `days` (string, optional): Number of days or 'all' (default: 30)

**Example:**
```http
GET /api/historical/global?days=7
```

**Response:**
```json
{
  "success": true,
  "data": {
    "cases": {
      "12/8/23": 649000000,
      "12/9/23": 649500000,
      "12/10/23": 650000000
    },
    "deaths": {
      "12/8/23": 6699000,
      "12/9/23": 6699500,
      "12/10/23": 6700000
    },
    "recovered": {
      "12/8/23": 624500000,
      "12/9/23": 624800000,
      "12/10/23": 625000000
    }
  },
  "timestamp": "2023-12-15T10:30:00Z"
}
```

#### Get Historical Country Data
Retrieve historical statistics for a specific country.

```http
GET /api/historical/:country
```

**Parameters:**
- `country` (string): Country name, ISO2, or ISO3 code

**Query Parameters:**
- `days` (string, optional): Number of days or 'all' (default: 30)

**Example:**
```http
GET /api/historical/USA?days=7
```

---

## 🏥 Health Check Endpoint

#### Server Health Check
Check if the API server is running and healthy.

```http
GET /api/health
```

**Response:**
```json
{
  "success": true,
  "status": "healthy",
  "timestamp": "2023-12-15T10:30:00Z",
  "uptime": 3600,
  "version": "2.0.0",
  "database": "connected",
  "cache": "active"
}
```

---

## ⚠️ Error Handling

### Error Response Format

All errors follow a consistent format:

```json
{
  "success": false,
  "error": {
    "code": "COUNTRY_NOT_FOUND",
    "message": "Country 'XYZ' not found",
    "details": "Please check the country name, ISO2, or ISO3 code"
  },
  "timestamp": "2023-12-15T10:30:00Z"
}
```

### HTTP Status Codes

| Status Code | Description |
|-------------|-------------|
| `200` | Success |
| `400` | Bad Request |
| `404` | Resource Not Found |
| `429` | Rate Limit Exceeded |
| `500` | Internal Server Error |
| `503` | Service Unavailable |

### Common Error Codes

| Error Code | Description |
|------------|-------------|
| `COUNTRY_NOT_FOUND` | Requested country doesn't exist |
| `INVALID_PARAMETER` | Invalid query parameter |
| `RATE_LIMIT_EXCEEDED` | Too many requests |
| `DATABASE_ERROR` | Database connection issue |
| `CACHE_ERROR` | Cache service unavailable |

---

## 🔄 Response Headers

### Standard Headers

```http
Content-Type: application/json; charset=utf-8
Cache-Control: public, max-age=1800
X-Response-Time: 45ms
X-API-Version: 2.0.0
```

### Rate Limiting Headers

```http
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 99
X-RateLimit-Reset: 1640995200
X-RateLimit-Window: 900
```

### Caching Headers

```http
X-Cache-Status: HIT
X-Cache-TTL: 1800
Last-Modified: Wed, 15 Dec 2023 10:00:00 GMT
ETag: "abc123def456"
```

---

## 📝 Data Sources

The API aggregates data from multiple reliable sources:

- **Johns Hopkins University CSSE**
- **Worldometers**
- **WHO (World Health Organization)**
- **CDC (Centers for Disease Control)**
- **Government Health Departments**

---

## 🔧 Rate Limiting

### Current Limits

- **Requests:** 100 per 15-minute window per IP
- **Burst:** 10 requests per second
- **Global:** 10,000 requests per hour

### Headers

Rate limiting information is provided in response headers:

```http
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 99
X-RateLimit-Reset: 1640995200
```

---

## 📱 SDKs and Libraries

### JavaScript/Node.js

```javascript
// Using fetch
const response = await fetch('https://your-api-domain.com/api/statistics/global');
const data = await response.json();

// Using axios
const axios = require('axios');
const response = await axios.get('https://your-api-domain.com/api/statistics/global');
const data = response.data;
```

### Python

```python
import requests

# Get global statistics
response = requests.get('https://your-api-domain.com/api/statistics/global')
data = response.json()
```

### cURL

```bash
# Get global statistics
curl -X GET "https://your-api-domain.com/api/statistics/global" \
  -H "Accept: application/json"

# Get country statistics
curl -X GET "https://your-api-domain.com/api/statistics/country/USA" \
  -H "Accept: application/json"
```

---

## 🧪 Testing the API

### Postman Collection

Import our Postman collection for easy API testing:

```json
{
  "info": {
    "name": "COVID-19 API",
    "description": "COVID-19 Full Stack Application API Collection",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Get Global Statistics",
      "request": {
        "method": "GET",
        "url": "{{baseUrl}}/api/statistics/global"
      }
    }
  ]
}
```

### Environment Variables

```json
{
  "baseUrl": "https://your-api-domain.com"
}
```

---

## 📊 Examples

### Get Top 10 Countries by Cases

```javascript
const response = await fetch('/api/statistics/countries?sort=cases&limit=10');
const data = await response.json();

data.data.forEach(country => {
  console.log(`${country.country}: ${country.cases} cases`);
});
```

### Create Map Markers

```javascript
const response = await fetch('/api/map/markers?threshold=1000');
const markers = await response.json();

markers.data.forEach(marker => {
  // Add marker to map
  addMarker({
    lat: marker.coordinates.latitude,
    lng: marker.coordinates.longitude,
    popup: `${marker.country}: ${marker.cases} cases`
  });
});
```

### Historical Data Chart

```javascript
const response = await fetch('/api/historical/global?days=30');
const historical = await response.json();

// Convert to chart data
const chartData = Object.keys(historical.data.cases).map(date => ({
  date,
  cases: historical.data.cases[date],
  deaths: historical.data.deaths[date]
}));
```

---

## 🐛 Troubleshooting

### Common Issues

1. **CORS Errors**
   - Ensure your domain is whitelisted
   - Check CORS_ORIGIN environment variable

2. **Rate Limit Exceeded**
   - Implement exponential backoff
   - Cache responses when possible

3. **Country Not Found**
   - Use correct country name or ISO codes
   - Check `/api/countries` for valid names

4. **Stale Data**
   - Data is cached for 30 minutes
   - Check `X-Cache-Status` header

---

## 🔄 Changelog

### Version 2.0.0 (2023-12-15)
- ✨ Added historical data endpoints
- ✨ Improved caching system
- ✨ Enhanced error handling
- 🔒 Added rate limiting
- 📊 Better response format

### Version 1.0.0 (2023-01-01)
- 🎉 Initial API release
- 📊 Global and country statistics
- 🗺️ Map markers endpoint
- 🏥 Health check endpoint

---

## 📞 Support

For API support and questions:

1. **Issues:** [GitHub Issues](https://github.com/saifyxpro/covid19-full-stack/issues)
2. **Discussions:** [GitHub Discussions](https://github.com/saifyxpro/covid19-full-stack/discussions)
3. **Email:** Create an issue for support

---

## 📄 License

This API is released under the MIT License. See [LICENSE](LICENSE) file for details.

---

**API Maintained by:** Saify (@saifyxpro)  
**Repository:** [saifyxpro/covid19-full-stack](https://github.com/saifyxpro/covid19-full-stack)  
**Last Updated:** December 15, 2023

---

*Happy coding! 🚀*
