export const FETCH_CORONA_STATISTICS = 'FETCH_CORONA_STATISTICS';
export const SHOW_COUNTRY_STATISTICS = 'SHOW_COUNTRY_STATISTICS';
export const FETCH_MARKERS = 'FETCH_MARKERS';
export const MAP_STYLE= 'MAP_STYLE';
export const SET_ACTION = 'SET_ACTION';
export const MAP_STYLE_ACTION = 'MAP_STYLE_ACTION';
export const MAP_FLY_ACTION = 'MAP_FLY_ACTION';

// API Configuration
export const BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:9000/api';
export const MAPBOX_ACCESS_TOKEN = process.env.REACT_APP_MAPBOX_TOKEN || 'YOUR_MAPBOX_API_TOKEN';

// Mapbox Styles
export const MAPBOX_STYLE_DARK = process.env.REACT_APP_MAPBOX_STYLE_DARK || 'mapbox://styles/hackbotone/ck8vtayrp0x5f1io3sakcmpnv';
export const MAPBOX_STYLE_LIGHT = process.env.REACT_APP_MAPBOX_STYLE_LIGHT || 'mapbox://styles/hackbotone/ck8vt8vdj2fz91ilax6nwtins';

// API Endpoints
export const ENDPOINTS = {
  STATISTICS: '/statistics',
  MARKERS: '/markers.geojson'
};