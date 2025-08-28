# 🔧 Troubleshooting Guide - COVID-19 Full Stack Application v2.0.0

**Created by [Saify (@saifyxpro)](https://github.com/saifyxpro)**  
**Repository:** https://github.com/saifyxpro/covid19-full-stack  
**Version:** 2.0.0 (2025)

This guide helps you resolve common issues when setting up and running the COVID-19 Full Stack Application.

## 📋 Table of Contents

- [Node.js Version Issues](#nodejs-version-issues)
- [Installation Problems](#installation-problems)
- [Development Server Issues](#development-server-issues)
- [MongoDB Connection Issues](#mongodb-connection-issues)
- [Mapbox Integration Issues](#mapbox-integration-issues)
- [Build and Deployment Issues](#build-and-deployment-issues)
- [CSS and Styling Issues](#css-and-styling-issues)
- [API and Network Issues](#api-and-network-issues)

## 🟡 Node.js Version Issues

### Problem: OpenSSL Legacy Provider Error
```
Error: error:0308010C:digital envelope routines::unsupported
```

**Solution 1: Use Node.js 18 LTS (Recommended)**
```bash
# Using nvm (recommended)
nvm install 18.20.4
nvm use 18.20.4

# Verify version
node --version  # Should show v18.20.4
```

**Solution 2: Use Legacy OpenSSL Provider**
The package.json has been updated with legacy provider flags:
```json
{
  "scripts": {
    "start": "react-scripts --openssl-legacy-provider start",
    "build": "react-scripts --openssl-legacy-provider build"
  }
}
```

**Solution 3: Environment Variable**
```bash
# Windows PowerShell
$env:NODE_OPTIONS="--openssl-legacy-provider"
npm start

# Windows CMD
set NODE_OPTIONS=--openssl-legacy-provider && npm start

# macOS/Linux
export NODE_OPTIONS=--openssl-legacy-provider
npm start
```

### Problem: Node.js Version Compatibility
```
Node.js version not supported
```

**Solution:**
```bash
# Check current version
node --version

# Install correct version (18.20.4 recommended)
nvm install 18.20.4
nvm use 18.20.4

# Or use the .nvmrc file
nvm use
```

## 📦 Installation Problems

### Problem: NPM Install Fails
```
npm ERR! code ERESOLVE
```

**Solution 1: Clear Cache and Reinstall**
```bash
# Clear npm cache
npm cache clean --force

# Delete node_modules and package-lock.json
rm -rf node_modules package-lock.json

# Reinstall
npm install
```

**Solution 2: Use Legacy Peer Deps**
```bash
npm install --legacy-peer-deps
```

**Solution 3: Use Yarn Instead**
```bash
# Install yarn
npm install -g yarn

# Install dependencies
yarn install
```

### Problem: Permission Errors (macOS/Linux)
```
EACCES: permission denied
```

**Solution:**
```bash
# Fix npm permissions
sudo chown -R $(whoami) ~/.npm

# Or install with sudo (not recommended)
sudo npm install
```

## 🚀 Development Server Issues

### Problem: Server Won't Start
```
Error: listen EADDRINUSE :::3000
```

**Solution 1: Kill Process on Port**
```bash
# Windows
netstat -ano | findstr :3000
taskkill /PID <PID> /F

# macOS/Linux  
lsof -ti:3000 | xargs kill -9
```

**Solution 2: Use Different Port**
```bash
# Set custom port
PORT=3001 npm start

# Or create .env file
echo "PORT=3001" > client/.env
```

### Problem: Hot Reload Not Working
**Solution:**
```bash
# Add to client/.env
FAST_REFRESH=true
CHOKIDAR_USEPOLLING=true
```

### Problem: CORS Errors in Development
**Solution:**
Add proxy to client/package.json:
```json
{
  "proxy": "http://localhost:9000"
}
```

## 🗄️ MongoDB Connection Issues

### Problem: Connection Refused
```
MongoNetworkError: connect ECONNREFUSED
```

**Solution 1: Start MongoDB Service**
```bash
# Windows (as Administrator)
net start MongoDB

# macOS
brew services start mongodb-community

# Linux
sudo systemctl start mongod
```

**Solution 2: Check MongoDB Status**
```bash
# Windows
sc query MongoDB

# macOS
brew services list | grep mongodb

# Linux
sudo systemctl status mongod
```

**Solution 3: Install MongoDB**
```bash
# Windows - Download from mongodb.com

# macOS
brew install mongodb-community

# Ubuntu/Debian
sudo apt-get install mongodb

# CentOS/RHEL
sudo yum install mongodb-org
```

### Problem: Authentication Failed
**Solution:**
Check your connection string in server/.env:
```bash
MONGODB_URI=mongodb://localhost:27017/covid-19
# Or with auth:
MONGODB_URI=mongodb://username:password@localhost:27017/covid-19
```

## 🗺️ Mapbox Integration Issues

### Problem: Map Not Loading
```
Error: A valid Mapbox access token is required
```

**Solution:**
1. Get free token from [Mapbox](https://www.mapbox.com/)
2. Add to client/.env:
```bash
REACT_APP_MAPBOX_TOKEN=your_token_here
```

### Problem: Map Styles Not Working
**Solution:**
Use default Mapbox styles in client/.env:
```bash
REACT_APP_MAPBOX_STYLE_DARK=mapbox://styles/mapbox/dark-v10
REACT_APP_MAPBOX_STYLE_LIGHT=mapbox://styles/mapbox/light-v10
```

### Problem: Map Performance Issues
**Solution:**
1. Reduce map complexity
2. Limit visible markers
3. Use clustering for many points

## 🏗️ Build and Deployment Issues

### Problem: Build Fails
```
npm ERR! Failed to compile
```

**Solution 1: Fix Linting Errors**
```bash
# Run linter
npm run lint

# Auto-fix issues
npm run lint:fix
```

**Solution 2: Check Dependencies**
```bash
# Update dependencies
npm update

# Check for vulnerabilities
npm audit fix
```

### Problem: Docker Build Fails
**Solution:**
```bash
# Build with no cache
docker-compose build --no-cache

# Check Docker logs
docker-compose logs web
```

### Problem: Production Build Size Too Large
**Solution:**
```bash
# Analyze bundle
npm run analyze

# Enable gzip compression in server
# Check webpack-bundle-analyzer output
```

## 🎨 CSS and Styling Issues

### Problem: Styles Not Loading
**Solution:**
1. Check CSS import order in index.css:
```css
@import './styles/variables.css';
@import './styles/utilities.css';
@import './styles/components.css';
```

2. Verify file paths are correct
3. Clear browser cache

### Problem: CSS Variables Not Working
**Solution:**
Ensure PostCSS is configured in postcss.config.js:
```json
{
  "plugins": [
    "autoprefixer",
    "postcss-custom-properties"
  ]
}
```

### Problem: Responsive Design Issues
**Solution:**
1. Check viewport meta tag in public/index.html
2. Verify breakpoints in variables.css
3. Test with browser dev tools

## 🌐 API and Network Issues

### Problem: API Calls Failing
```
Failed to fetch from server
```

**Solution 1: Check Server Status**
```bash
# Test server health
curl http://localhost:9000/api/health

# Or visit in browser
http://localhost:9000/api/health
```

**Solution 2: Check CORS Configuration**
Verify CORS settings in server/app.js:
```javascript
app.use(cors({
  origin: ['http://localhost:3000', 'http://localhost:3001'],
  credentials: true
}));
```

**Solution 3: Check Environment Variables**
Verify API URL in client/.env:
```bash
REACT_APP_API_URL=http://localhost:9000/api
```

### Problem: Rate Limiting Errors
```
Too Many Requests (429)
```

**Solution:**
Wait for rate limit reset or adjust limits in server/app.js:
```javascript
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 200 // increase limit
});
```

## 🔍 General Debugging Tips

### 1. Check Logs
```bash
# Client console (browser dev tools)
F12 → Console tab

# Server logs
tail -f server/logs/combined.log

# PM2 logs (production)
pm2 logs covid-api
```

### 2. Verify Environment Variables
```bash
# Check current environment
echo $NODE_ENV

# List all env vars
printenv | grep REACT_APP
```

### 3. Clear All Caches
```bash
# NPM cache
npm cache clean --force

# Browser cache
Ctrl+Shift+R (hard refresh)

# Node modules
rm -rf node_modules package-lock.json
npm install
```

### 4. Check Network Connectivity
```bash
# Test external API
curl "https://disease.sh/v3/covid-19/all"

# Test local server
curl http://localhost:9000/api/health
```

## 🆘 Getting Help

If you're still experiencing issues:

1. **Check existing issues:** [GitHub Issues](https://github.com/saifyxpro/covid19-full-stack/issues)
2. **Create detailed bug report:** Include error messages, environment details, and steps to reproduce
3. **Provide system information:**
   ```bash
   node --version
   npm --version
   git --version
   ```

### Bug Report Template
```markdown
**Environment:**
- OS: [Windows 11 / macOS 14 / Ubuntu 22.04]
- Node.js version: [18.20.4]
- npm version: [10.7.0]
- Browser: [Chrome 118.0]

**Issue Description:**
Brief description of the problem

**Steps to Reproduce:**
1. Step one
2. Step two
3. Error occurs

**Error Messages:**
```
Paste error messages here
```

**Expected Behavior:**
What should happen

**Additional Context:**
Any other relevant information
```

## 📞 Support Channels

- **GitHub Issues:** [Create Issue](https://github.com/saifyxpro/covid19-full-stack/issues)
- **Documentation:** [Wiki](https://github.com/saifyxpro/covid19-full-stack/wiki)
- **Developer:** [Saify (@saifyxpro)](https://github.com/saifyxpro)

---

**Made with ❤️ by [Saify (@saifyxpro)](https://github.com/saifyxpro)**
