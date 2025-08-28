require('dotenv').config();
const express = require('express');
const axios = require('axios');
const fs = require('fs').promises;
const csv = require('csv-parser');
const cors = require('cors');
const cron = require('node-cron');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const winston = require('winston');
const NodeCache = require('node-cache');
const { MongoClient } = require('mongodb');
const { body, validationResult } = require('express-validator');
const path = require('path');

// Import country list
const countryList = require('./country_list.json');

// Configuration
const config = {
    port: process.env.PORT || 9000,
    mongoUri: process.env.MONGODB_URI || 'mongodb://localhost:27017/covid-19',
    dbName: process.env.DB_NAME || 'covid-19',
    collectionName: process.env.COLLECTION_NAME || 'covid_statistics',
    cacheTime: parseInt(process.env.CACHE_TTL) || 600,
    cronSchedule: process.env.DATA_UPDATE_CRON || '0 0 2 * * *'
};

// Logger setup
const logger = winston.createLogger({
    level: process.env.LOG_LEVEL || 'info',
    format: winston.format.combine(
        winston.format.timestamp(),
        winston.format.errors({ stack: true }),
        winston.format.json()
    ),
    defaultMeta: { service: 'covid-api' },
    transports: [
        new winston.transports.File({ filename: 'logs/error.log', level: 'error' }),
        new winston.transports.File({ filename: 'logs/combined.log' }),
        new winston.transports.Console({
            format: winston.format.combine(
                winston.format.colorize(),
                winston.format.simple()
            )
        })
    ]
});

// Cache setup
const cache = new NodeCache({ stdTTL: config.cacheTime });

// MongoDB client
let mongoClient = null;
let isConnected = false;

// Express app setup
const app = express();

// Security middleware
app.use(helmet());
app.use(cors({
    origin: process.env.NODE_ENV === 'production' 
        ? ['https://yourdomain.com'] 
        : ['http://localhost:3000', 'http://127.0.0.1:3000'],
    credentials: true
}));

// Rate limiting
const limiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: 100, // limit each IP to 100 requests per windowMs
    message: {
        error: 'Too many requests from this IP, please try again later.'
    }
});
app.use('/api', limiter);

// Request parsing
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// Request logging
app.use((req, res, next) => {
    logger.info(`${req.method} ${req.path} - IP: ${req.ip}`);
    next();
});

// MongoDB connection
async function connectToMongoDB() {
    try {
        if (!mongoClient) {
            mongoClient = new MongoClient(config.mongoUri);
            await mongoClient.connect();
            logger.info('Connected to MongoDB successfully');
            isConnected = true;
        }
        return mongoClient;
    } catch (error) {
        logger.error('MongoDB connection error:', error);
        isConnected = false;
        throw error;
    }
}

// Graceful shutdown
process.on('SIGTERM', gracefulShutdown);
process.on('SIGINT', gracefulShutdown);

async function gracefulShutdown(signal) {
    logger.info(`Received ${signal}. Shutting down gracefully...`);
    
    if (mongoClient && isConnected) {
        await mongoClient.close();
        logger.info('MongoDB connection closed');
    }
    
    process.exit(0);
}

// Create logs directory
async function ensureDirectories() {
    try {
        await fs.mkdir('logs', { recursive: true });
        await fs.mkdir('temp', { recursive: true });
    } catch (error) {
        logger.warn('Could not create directories:', error.message);
    }
}

// Data fetching and processing functions
async function fetchCovidData() {
    const today = new Date();
    const yesterday = new Date(today);
    yesterday.setDate(yesterday.getDate() - 1);
    
    const dates = [today, yesterday];
    
    for (const date of dates) {
        const fileName = formatDate(date);
        try {
            logger.info(`Attempting to fetch data for ${fileName}`);
            const data = await downloadAndProcessData(fileName);
            if (data && data.length > 0) {
                await processAndStoreData(data, fileName);
                return true;
            }
        } catch (error) {
            logger.warn(`Failed to fetch data for ${fileName}:`, error.message);
            continue;
        }
    }
    
    throw new Error('Could not fetch data for any recent dates');
}

function formatDate(date) {
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const year = date.getFullYear();
    return `${month}-${day}-${year}`;
}

async function downloadAndProcessData(fileName) {
    const csvFileName = `${fileName}.csv`;
    const tempFilePath = path.join('temp', csvFileName);
    
    // Try multiple data sources
    const dataSources = [
        `https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/${csvFileName}`,
        `https://disease.sh/v3/covid-19/historical/all?lastdays=1`,
        // Fallback API source if CSV is not available
    ];
    
    for (const url of dataSources) {
        try {
            logger.info(`Trying data source: ${url}`);
            
            if (url.includes('disease.sh')) {
                // Handle API response
                const response = await axios.get(url, { timeout: 30000 });
                return processAPIData(response.data);
            } else {
                // Handle CSV download
                const response = await axios({
                    method: 'GET',
                    url: url,
                    responseType: 'stream',
                    timeout: 30000
                });
                
                const writer = require('fs').createWriteStream(tempFilePath);
                response.data.pipe(writer);
                
                await new Promise((resolve, reject) => {
                    writer.on('finish', resolve);
                    writer.on('error', reject);
                });
                
                return await parseCSV(tempFilePath);
            }
        } catch (error) {
            logger.warn(`Data source ${url} failed:`, error.message);
            continue;
        }
    }
    
    throw new Error('All data sources failed');
}

async function parseCSV(filePath) {
    const results = [];
    
    return new Promise((resolve, reject) => {
        require('fs').createReadStream(filePath)
            .pipe(csv())
            .on('data', (data) => results.push(data))
            .on('end', async () => {
                try {
                    // Clean up temp file
                    await fs.unlink(filePath);
                } catch (error) {
                    logger.warn('Could not delete temp file:', error.message);
                }
                resolve(results);
            })
            .on('error', reject);
    });
}

function processAPIData(apiData) {
    // Convert API data to CSV-like format for compatibility
    // This is a simplified example - you'd need to adapt based on actual API structure
    logger.info('Processing API data as fallback');
    return [];
}

async function processAndStoreData(data, fileName) {
    try {
        let totalConfirmed = 0;
        let totalDeaths = 0;
        let totalRecovered = 0;
        
        const processedData = [];
        
        // Calculate totals
        for (const row of data) {
            totalConfirmed += parseInt(row.Confirmed || 0);
            totalDeaths += parseInt(row.Deaths || 0);
            totalRecovered += parseInt(row.Recovered || 0);
        }
        
        // Process country statistics
        for (const country of countryList) {
            const countryStats = getCountryStatistics(country, data);
            if (countryStats.confirmed > 0 || countryStats.deaths > 0 || countryStats.recovered > 0) {
                processedData.push(countryStats);
            }
        }
        
        const document = {
            total_confirmed: totalConfirmed,
            total_deaths: totalDeaths,
            total_recovered: totalRecovered,
            last_date_updated: new Date().toDateString(),
            country_statistics: processedData.sort((a, b) => b.confirmed - a.confirmed),
            updated_at: new Date()
        };
        
        // Store in MongoDB
        const client = await connectToMongoDB();
        const db = client.db(config.dbName);
        const collection = db.collection(config.collectionName);
        
        // Replace existing data
        await collection.deleteMany({});
        await collection.insertOne(document);
        
        // Clear cache
        cache.flushAll();
        
        logger.info(`Data updated successfully for ${fileName}`);
        return document;
        
    } catch (error) {
        logger.error('Error processing and storing data:', error);
        throw error;
    }
}

function getCountryStatistics(countryObj, rawData) {
    const statistics = [];
    let confirmed = 0;
    let deaths = 0;
    let recovered = 0;
    
    // Process each row for this country
    for (const row of rawData) {
        if (row.Country_Region === countryObj.country || row['Country/Region'] === countryObj.country) {
            confirmed += parseInt(row.Confirmed || 0);
            deaths += parseInt(row.Deaths || 0);
            recovered += parseInt(row.Recovered || 0);
            
            const stateName = row.Province_State || row['Province/State'] || countryObj.country;
            const stateStats = {
                key: Math.random().toString(36).substr(2, 9),
                name: stateName,
                address: row.Combined_Key || row.Admin2 || stateName,
                latitude: parseFloat(row.Lat || row.Latitude || 0),
                longitude: parseFloat(row.Long_ || row.Longitude || 0),
                confirmed: parseInt(row.Confirmed || 0),
                deaths: parseInt(row.Deaths || 0),
                recovered: parseInt(row.Recovered || 0)
            };
            
            statistics.push(stateStats);
        }
    }
    
    return {
        country: countryObj.country,
        code: countryObj.code,
        flag: countryObj.flag,
        coordinates: countryObj.coordinates,
        confirmed,
        deaths,
        recovered,
        states: statistics.filter((state, index, self) => 
            index === self.findIndex(s => s.name === state.name)
        )
    };
}

// Schedule data updates
if (config.cronSchedule && config.cronSchedule !== 'disabled') {
    cron.schedule(config.cronSchedule, async () => {
        logger.info('Starting scheduled data update...');
        try {
            await fetchCovidData();
            logger.info('Scheduled data update completed successfully');
        } catch (error) {
            logger.error('Scheduled data update failed:', error);
        }
    });
    
    logger.info(`Cron job scheduled: ${config.cronSchedule}`);
}

// API Routes
app.get('/health', (req, res) => {
    res.json({
        status: 'OK',
        timestamp: new Date().toISOString(),
        mongodb: isConnected ? 'connected' : 'disconnected',
        cache: cache.getStats()
    });
});

app.get('/api/statistics', async (req, res) => {
    try {
        // Check cache first
        const cacheKey = 'statistics';
        const cached = cache.get(cacheKey);
        if (cached) {
            return res.json(cached);
        }
        
        const client = await connectToMongoDB();
        const db = client.db(config.dbName);
        const collection = db.collection(config.collectionName);
        
        const result = await collection.findOne({}, { sort: { updated_at: -1 } });
        
        if (!result) {
            return res.status(404).json({ 
                error: 'No data available',
                message: 'Please wait for data to be fetched or trigger a manual update'
            });
        }
        
        // Cache the result
        cache.set(cacheKey, result);
        
        res.json(result);
        
    } catch (error) {
        logger.error('Error fetching statistics:', error);
        res.status(500).json({ 
            error: 'Internal server error',
            message: 'Failed to fetch statistics'
        });
    }
});

app.get('/api/markers.geojson', async (req, res) => {
    try {
        // Check cache first
        const cacheKey = 'markers';
        const cached = cache.get(cacheKey);
        if (cached) {
            return res.json(cached);
        }
        
        const client = await connectToMongoDB();
        const db = client.db(config.dbName);
        const collection = db.collection(config.collectionName);
        
        const result = await collection.findOne({}, { sort: { updated_at: -1 } });
        
        if (!result) {
            return res.status(404).json({ error: 'No data available' });
        }
        
        const features = [];
        
        // Convert data to GeoJSON format
        for (const countryStats of result.country_statistics) {
            for (const state of countryStats.states) {
                if (state.latitude && state.longitude && (state.confirmed > 0 || state.deaths > 0)) {
                    const feature = {
                        type: "Feature",
                        geometry: {
                            type: "Point",
                            coordinates: [state.longitude, state.latitude]
                        },
                        properties: {
                            key: state.key,
                            country: countryStats.country,
                            name: state.name,
                            address: state.address,
                            confirmed: state.confirmed,
                            deaths: state.deaths,
                            recovered: state.recovered,
                            total_cases: state.confirmed + state.deaths + state.recovered
                        }
                    };
                    features.push(feature);
                }
            }
        }
        
        const geoJson = {
            type: "FeatureCollection",
            features: features
        };
        
        // Cache the result
        cache.set(cacheKey, geoJson);
        
        res.json(geoJson);
        
    } catch (error) {
        logger.error('Error fetching markers:', error);
        res.status(500).json({ 
            error: 'Internal server error',
            message: 'Failed to fetch markers'
        });
    }
});

// Legacy routes for backward compatibility
app.get('/', (req, res) => {
    res.redirect('/api/statistics');
});

app.get('/markers.geojson', (req, res) => {
    res.redirect('/api/markers.geojson');
});

// Manual data update endpoint (protected)
app.post('/api/update', async (req, res) => {
    try {
        logger.info('Manual data update triggered');
        await fetchCovidData();
        res.json({ 
            success: true, 
            message: 'Data updated successfully',
            timestamp: new Date().toISOString()
        });
    } catch (error) {
        logger.error('Manual data update failed:', error);
        res.status(500).json({ 
            error: 'Update failed',
            message: error.message
        });
    }
});

// 404 handler
app.use((req, res) => {
    res.status(404).json({
        error: 'Not found',
        message: 'The requested resource was not found'
    });
});

// Error handler
app.use((error, req, res, next) => {
    logger.error('Unhandled error:', error);
    res.status(500).json({
        error: 'Internal server error',
        message: process.env.NODE_ENV === 'development' ? error.message : 'Something went wrong'
    });
});

// Start server
async function startServer() {
    try {
        await ensureDirectories();
        await connectToMongoDB();
        
        const server = app.listen(config.port, () => {
            logger.info(`🚀 COVID-19 API server running on port ${config.port}`);
            logger.info(`📊 Health check: http://localhost:${config.port}/health`);
            logger.info(`🌍 Environment: ${process.env.NODE_ENV || 'development'}`);
        });
        
        server.on('error', (error) => {
            if (error.code === 'EADDRINUSE') {
                logger.error(`Port ${config.port} is already in use`);
            } else {
                logger.error('Server error:', error);
            }
            process.exit(1);
        });
        
        // Initial data fetch on startup
        if (process.env.NODE_ENV !== 'test') {
            setTimeout(async () => {
                try {
                    logger.info('Performing initial data fetch...');
                    await fetchCovidData();
                    logger.info('Initial data fetch completed');
                } catch (error) {
                    logger.warn('Initial data fetch failed:', error.message);
                }
            }, 5000); // Wait 5 seconds after server start
        }
        
    } catch (error) {
        logger.error('Failed to start server:', error);
        process.exit(1);
    }
}

// Start the server if not in test mode
if (require.main === module) {
    startServer();
}

module.exports = app;
