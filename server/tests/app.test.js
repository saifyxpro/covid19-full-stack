const request = require('supertest');
const app = require('../app');

describe('COVID-19 API Endpoints', () => {
  describe('GET /health', () => {
    it('should return health status', async () => {
      const response = await request(app)
        .get('/health')
        .expect(200);
      
      expect(response.body).toHaveProperty('status', 'OK');
      expect(response.body).toHaveProperty('timestamp');
      expect(response.body).toHaveProperty('mongodb');
    });
  });

  describe('GET /api/statistics', () => {
    it('should return statistics or 404 if no data', async () => {
      const response = await request(app)
        .get('/api/statistics');
      
      expect([200, 404]).toContain(response.status);
      
      if (response.status === 200) {
        expect(response.body).toHaveProperty('total_confirmed');
        expect(response.body).toHaveProperty('country_statistics');
      }
    });
  });

  describe('GET /api/markers.geojson', () => {
    it('should return GeoJSON markers or 404 if no data', async () => {
      const response = await request(app)
        .get('/api/markers.geojson');
      
      expect([200, 404]).toContain(response.status);
      
      if (response.status === 200) {
        expect(response.body).toHaveProperty('type', 'FeatureCollection');
        expect(response.body).toHaveProperty('features');
        expect(Array.isArray(response.body.features)).toBe(true);
      }
    });
  });

  describe('GET /non-existent-endpoint', () => {
    it('should return 404 for non-existent endpoints', async () => {
      const response = await request(app)
        .get('/non-existent-endpoint')
        .expect(404);
      
      expect(response.body).toHaveProperty('error', 'Not found');
    });
  });
});
