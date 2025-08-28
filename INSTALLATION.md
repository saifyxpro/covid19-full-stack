# 📋 Installation Guide - COVID-19 Full Stack Application

This guide will help you set up the COVID-19 Full Stack Application on your local machine or production server.

## 🎯 Quick Start (Recommended)

### Option 1: Automated Setup

**Windows:**
```cmd
# Run the automated deployment script
deploy.bat
```

**macOS/Linux:**
```bash
# Make script executable and run
chmod +x deploy.sh
./deploy.sh
```

### Option 2: Manual Installation

Follow the steps below for manual installation.

---

## 📋 Prerequisites

Before installing, ensure you have the following installed on your system:

### Required Software

1. **Node.js (v16 or higher)**
   - Download: [nodejs.org](https://nodejs.org/)
   - Verify installation: `node --version`

2. **MongoDB (v5 or higher)**
   - Download: [mongodb.com/try/download/community](https://www.mongodb.com/try/download/community)
   - Verify installation: `mongod --version`

3. **Git**
   - Download: [git-scm.com](https://git-scm.com/)
   - Verify installation: `git --version`

### Optional (for production)
- **Docker & Docker Compose**: [docker.com](https://www.docker.com/)
- **PM2**: `npm install -g pm2`

---

## 🚀 Installation Steps

### Step 1: Clone Repository

```bash
git clone https://github.com/anshumanpattnaik/covid19-full-stack-application.git
cd covid19-full-stack-application
```

### Step 2: Start MongoDB

**Windows:**
```cmd
# Start MongoDB service or run
mongod
```

**macOS (with Homebrew):**
```bash
brew services start mongodb-community
```

**Linux (systemd):**
```bash
sudo systemctl start mongod
```

### Step 3: Import Sample Data

```bash
mongoimport --uri "mongodb://127.0.0.1:27017/covid-19" --collection covid_statistics --file dummy_statistics.json --drop
```

### Step 4: Server Setup

```bash
# Navigate to server directory
cd server

# Install dependencies
npm install

# Copy environment template
cp .env.example .env

# Edit .env file with your settings
# (Use any text editor like notepad, nano, vim, etc.)

# Create necessary directories
mkdir logs temp

# Start development server
npm run dev
```

**Server Environment Variables (.env):**
```env
PORT=9000
NODE_ENV=development
MONGODB_URI=mongodb://localhost:27017/covid-19
DB_NAME=covid-19
COLLECTION_NAME=covid_statistics
DATA_UPDATE_CRON=0 0 2 * * *
CACHE_TTL=600
LOG_LEVEL=info
```

### Step 5: Client Setup

```bash
# Open new terminal and navigate to client directory
cd client

# Install dependencies
npm install

# Copy environment template
cp .env.example .env

# Edit .env file with your Mapbox token
# Get token from: https://account.mapbox.com/

# Start development server
npm start
```

**Client Environment Variables (.env):**
```env
REACT_APP_API_URL=http://localhost:9000/api
REACT_APP_MAPBOX_TOKEN=your_mapbox_token_here
REACT_APP_MAPBOX_STYLE_DARK=mapbox://styles/hackbotone/ck8vtayrp0x5f1io3sakcmpnv
REACT_APP_MAPBOX_STYLE_LIGHT=mapbox://styles/hackbotone/ck8vt8vdj2fz91ilax6nwtins
GENERATE_SOURCEMAP=true
```

### Step 6: Access Application

- **Client:** [http://localhost:3000](http://localhost:3000)
- **Server:** [http://localhost:9000](http://localhost:9000)
- **Health Check:** [http://localhost:9000/health](http://localhost:9000/health)

---

## 🔑 Getting Mapbox API Token

1. Visit [mapbox.com](https://www.mapbox.com/)
2. Create a free account (if you don't have one)
3. Go to your [Account page](https://account.mapbox.com/)
4. Find your **Default public token** or create a new token
5. Copy the token to your `client/.env` file

**Free tier includes:**
- 50,000 map loads per month
- 2GB of storage
- All basic map styles

---

## 🐳 Docker Installation

### Using Docker Compose (Recommended for Production)

```bash
# Build and start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### Manual Docker Setup

```bash
# Build and run MongoDB
docker run -d --name covid-mongodb -p 27017:27017 mongo:6

# Build server
cd server
docker build -t covid-server .
docker run -d --name covid-server --link covid-mongodb:mongodb -p 9000:9000 covid-server

# Build client
cd ../client
docker build -t covid-client .
docker run -d --name covid-client --link covid-server:server -p 80:80 covid-client
```

---

## 🔧 Development Setup

### Server Development

```bash
cd server

# Install development dependencies
npm install

# Run with automatic restart on changes
npm run dev

# Run tests
npm test

# Run tests with coverage
npm test -- --coverage
```

### Client Development

```bash
cd client

# Install dependencies
npm install

# Start development server with hot reload
npm start

# Run tests
npm test

# Build for production
npm run build
```

---

## 🚚 Production Deployment

### Environment Setup

1. **Set production environment variables**
2. **Configure secure MongoDB connection**
3. **Set up SSL/HTTPS certificates**
4. **Configure reverse proxy (nginx)**
5. **Set up process manager (PM2)**

### PM2 Deployment

```bash
# Install PM2 globally
npm install -g pm2

# Start server with PM2
cd server
pm2 start app.js --name "covid-api"

# Build and serve client
cd ../client
npm run build
pm2 serve build/ 3000 --spa --name "covid-client"

# Save PM2 configuration
pm2 save
pm2 startup
```

### Nginx Configuration

```nginx
server {
    listen 80;
    server_name your-domain.com;
    
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
    
    location /api {
        proxy_pass http://localhost:9000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

---

## 🛠 Troubleshooting

### Common Issues

#### 1. **"Port already in use" Error**

```bash
# Find process using port
netstat -ano | findstr :9000  # Windows
lsof -i :9000                 # macOS/Linux

# Kill process
taskkill /PID <PID> /F        # Windows
kill -9 <PID>                 # macOS/Linux
```

#### 2. **MongoDB Connection Failed**

- Ensure MongoDB is running
- Check MongoDB URI in `.env` file
- Verify MongoDB is accessible on specified port
- Check firewall settings

#### 3. **Missing Dependencies**

```bash
# Clear npm cache and reinstall
npm cache clean --force
rm -rf node_modules package-lock.json
npm install
```

#### 4. **Mapbox Map Not Loading**

- Verify Mapbox token is correct
- Check browser console for errors
- Ensure token has necessary permissions
- Check network connectivity

#### 5. **Data Not Updating**

```bash
# Trigger manual update
curl -X POST http://localhost:9000/api/update

# Check server logs
tail -f server/logs/combined.log
```

### Log Locations

- **Server logs:** `server/logs/`
- **Client build logs:** Check browser console
- **MongoDB logs:** Check MongoDB installation directory
- **PM2 logs:** `pm2 logs`

### Health Checks

```bash
# Server health
curl http://localhost:9000/health

# API endpoints
curl http://localhost:9000/api/statistics
curl http://localhost:9000/api/markers.geojson
```

---

## 🧪 Testing

### Running Tests

```bash
# Server tests
cd server
npm test

# Client tests
cd client
npm test

# Run all tests with coverage
npm run test:coverage
```

### Manual Testing Checklist

- [ ] Server starts without errors
- [ ] Client loads successfully
- [ ] API endpoints return data
- [ ] Map displays with markers
- [ ] Country statistics show correctly
- [ ] Data updates work (manual trigger)
- [ ] Responsive design works on mobile

---

## 📞 Support

If you encounter issues not covered in this guide:

1. **Check the logs** in `server/logs/` directory
2. **Verify environment variables** are set correctly
3. **Ensure all prerequisites** are installed and running
4. **Check GitHub issues** for similar problems
5. **Create a new issue** with detailed error information

### Support Resources

- [Original Repository](https://github.com/anshumanpattnaik/covid19-full-stack-application)
- [Node.js Documentation](https://nodejs.org/docs/)
- [MongoDB Documentation](https://docs.mongodb.com/)
- [React Documentation](https://reactjs.org/docs/)
- [Mapbox Documentation](https://docs.mapbox.com/)

---

## ✅ Installation Complete

Once everything is working:

1. **Bookmark important URLs**
2. **Set up monitoring** (optional)
3. **Configure backups** (for production)
4. **Set up SSL certificates** (for production)
5. **Monitor logs** regularly

**Enjoy exploring COVID-19 data visualization! 🎉**
