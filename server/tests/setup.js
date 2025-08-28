// Test setup file
process.env.NODE_ENV = 'test';
process.env.MONGODB_URI = 'mongodb://localhost:27017/covid-19-test';
process.env.LOG_LEVEL = 'error';
process.env.DATA_UPDATE_CRON = 'disabled';

// Suppress console.log during tests
global.console = {
  ...console,
  log: jest.fn(),
  info: jest.fn(),
  warn: jest.fn(),
};
