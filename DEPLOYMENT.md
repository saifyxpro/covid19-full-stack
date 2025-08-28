# 🚀 Deployment Guide

This guide covers various deployment options for the COVID-19 Full Stack Application.

## 📋 Prerequisites

Before deploying, ensure you have:

- ✅ Node.js 16+ installed
- ✅ MongoDB instance (local or cloud)
- ✅ Environment variables configured
- ✅ Application tested locally
- ✅ Production build created

## 🌐 Environment Configuration

### Production Environment Variables

#### Server (.env)
```env
# Server Configuration
PORT=5000
NODE_ENV=production

# Database
MONGODB_URI=mongodb://your-mongodb-connection-string

# Security
CORS_ORIGIN=https://your-domain.com
API_RATE_LIMIT=50

# Logging
LOG_LEVEL=error
```

#### Client (.env)
```env
# API Configuration
REACT_APP_API_URL=https://your-api-domain.com

# External Services
REACT_APP_MAP_API_KEY=your-production-map-api-key
```

## 🐳 Docker Deployment

### Using Docker Compose (Recommended)

1. **Clone and configure**
   ```bash
   git clone https://github.com/saifyxpro/covid19-full-stack.git
   cd covid19-full-stack
   ```

2. **Configure environment**
   ```bash
   cp server/.env.example server/.env
   cp client/.env.example client/.env
   # Edit the .env files with production values
   ```

3. **Deploy with Docker Compose**
   ```bash
   docker-compose -f docker-compose.prod.yml up -d --build
   ```

### Individual Docker Containers

#### Server Container
```bash
cd server
docker build -t covid19-server .
docker run -d -p 5000:5000 --env-file .env --name covid19-server covid19-server
```

#### Client Container
```bash
cd client
docker build -t covid19-client .
docker run -d -p 3000:80 --env-file .env --name covid19-client covid19-client
```

## ☁️ Cloud Platform Deployments

### Heroku Deployment

#### Server Deployment
1. **Create Heroku app**
   ```bash
   heroku create covid19-server-app
   ```

2. **Set environment variables**
   ```bash
   heroku config:set NODE_ENV=production
   heroku config:set MONGODB_URI=your-mongodb-uri
   heroku config:set CORS_ORIGIN=https://your-client-app.herokuapp.com
   ```

3. **Deploy**
   ```bash
   git subtree push --prefix server heroku main
   ```

#### Client Deployment
1. **Create Heroku app**
   ```bash
   heroku create covid19-client-app
   heroku buildpacks:set mars/create-react-app
   ```

2. **Set environment variables**
   ```bash
   heroku config:set REACT_APP_API_URL=https://covid19-server-app.herokuapp.com
   ```

3. **Deploy**
   ```bash
   git subtree push --prefix client heroku main
   ```

### Netlify Deployment (Client)

1. **Build the client**
   ```bash
   cd client
   npm run build
   ```

2. **Deploy to Netlify**
   - Connect your GitHub repository to Netlify
   - Set build command: `npm run build`
   - Set publish directory: `build`
   - Add environment variables in Netlify dashboard

### Vercel Deployment (Client)

1. **Install Vercel CLI**
   ```bash
   npm install -g vercel
   ```

2. **Deploy**
   ```bash
   cd client
   vercel --prod
   ```

### AWS Deployment

#### Using AWS Elastic Beanstalk

1. **Install EB CLI**
   ```bash
   pip install awsebcli
   ```

2. **Initialize and deploy**
   ```bash
   cd server
   eb init
   eb create production
   eb deploy
   ```

#### Using AWS ECS with Docker

1. **Build and push images**
   ```bash
   # Build images
   docker build -t covid19-server ./server
   docker build -t covid19-client ./client

   # Tag for ECR
   docker tag covid19-server:latest your-account.dkr.ecr.region.amazonaws.com/covid19-server:latest
   docker tag covid19-client:latest your-account.dkr.ecr.region.amazonaws.com/covid19-client:latest

   # Push to ECR
   docker push your-account.dkr.ecr.region.amazonaws.com/covid19-server:latest
   docker push your-account.dkr.ecr.region.amazonaws.com/covid19-client:latest
   ```

2. **Create ECS task definition and service**
   (Use AWS Console or CloudFormation templates)

### Google Cloud Platform

#### Using Google App Engine

1. **Create app.yaml for server**
   ```yaml
   runtime: nodejs16
   env_variables:
     NODE_ENV: production
     MONGODB_URI: your-mongodb-uri
   ```

2. **Deploy**
   ```bash
   cd server
   gcloud app deploy
   ```

### Digital Ocean App Platform

1. **Create app spec**
   ```yaml
   name: covid19-app
   services:
   - name: server
     source_dir: /server
     github:
       repo: saifyxpro/covid19-full-stack
       branch: main
     run_command: npm start
     environment_slug: node-js
     instance_count: 1
     instance_size_slug: basic-xxs
     envs:
     - key: NODE_ENV
       value: production
   - name: client
     source_dir: /client
     github:
       repo: saifyxpro/covid19-full-stack
       branch: main
     run_command: npm start
     environment_slug: node-js
     instance_count: 1
     instance_size_slug: basic-xxs
   ```

## 🗄️ Database Deployment

### MongoDB Atlas (Cloud)
1. Create MongoDB Atlas cluster
2. Get connection string
3. Update `MONGODB_URI` in environment variables
4. Whitelist deployment server IPs

### Self-hosted MongoDB
```bash
# Using Docker
docker run -d -p 27017:27017 -v mongodb_data:/data/db --name mongodb mongo:6.0

# Using systemd (Ubuntu/Debian)
sudo systemctl start mongod
sudo systemctl enable mongod
```

## 🔒 SSL/TLS Configuration

### Using Let's Encrypt with Nginx

1. **Install Certbot**
   ```bash
   sudo apt-get install certbot python3-certbot-nginx
   ```

2. **Nginx configuration**
   ```nginx
   server {
       listen 80;
       server_name your-domain.com;
       return 301 https://$server_name$request_uri;
   }

   server {
       listen 443 ssl http2;
       server_name your-domain.com;

       ssl_certificate /etc/letsencrypt/live/your-domain.com/fullchain.pem;
       ssl_certificate_key /etc/letsencrypt/live/your-domain.com/privkey.pem;

       location / {
           proxy_pass http://localhost:3000;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection 'upgrade';
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }

       location /api {
           proxy_pass http://localhost:5000;
           proxy_http_version 1.1;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header Host $http_host;
           proxy_set_header X-Forwarded-Proto $scheme;
       }
   }
   ```

3. **Get SSL certificate**
   ```bash
   sudo certbot --nginx -d your-domain.com
   ```

## 📊 Monitoring and Logging

### PM2 Process Management
```bash
# Install PM2
npm install -g pm2

# Start with PM2
cd server
pm2 start ecosystem.config.js

# Monitor
pm2 monit
pm2 logs
```

### Docker Health Checks
```dockerfile
# In Dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:5000/health || exit 1
```

## 🚀 Automated Deployment

### GitHub Actions CI/CD

See `.github/workflows/ci-cd.yml` for automated deployment pipeline.

### Deployment Script

```bash
#!/bin/bash
# deploy-prod.sh

set -e

echo "🚀 Starting production deployment..."

# Pull latest changes
git pull origin main

# Build client
cd client
npm ci --production
npm run build
cd ..

# Deploy server
cd server
npm ci --production
pm2 reload ecosystem.config.js
cd ..

echo "✅ Deployment completed successfully!"
```

## 🔧 Performance Optimization

### Client Optimization
- Enable gzip compression
- Use CDN for static assets
- Implement service worker caching
- Optimize bundle size

### Server Optimization
- Enable response compression
- Implement Redis caching
- Use connection pooling for MongoDB
- Set up load balancing

## 📈 Scaling

### Horizontal Scaling
```yaml
# docker-compose.scale.yml
version: '3.8'
services:
  server:
    build: ./server
    deploy:
      replicas: 3
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
```

### Load Balancer Configuration
```nginx
upstream backend {
    server server1:5000;
    server server2:5000;
    server server3:5000;
}

server {
    location /api {
        proxy_pass http://backend;
    }
}
```

## 🐛 Troubleshooting

### Common Issues

1. **Port conflicts**
   ```bash
   sudo lsof -i :5000
   sudo kill -9 <PID>
   ```

2. **Memory issues**
   ```bash
   # Increase Node.js memory
   NODE_OPTIONS="--max-old-space-size=4096" npm start
   ```

3. **Database connection issues**
   - Check firewall settings
   - Verify connection string
   - Check MongoDB logs

4. **SSL certificate issues**
   ```bash
   sudo certbot renew --dry-run
   sudo systemctl reload nginx
   ```

## 📞 Support

For deployment issues:

1. Check [GitHub Issues](https://github.com/saifyxpro/covid19-full-stack/issues)
2. Review deployment logs
3. Create a support ticket with detailed error information

---

## 📚 Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [MongoDB Atlas Documentation](https://docs.atlas.mongodb.com/)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [PM2 Documentation](https://pm2.keymetrics.io/docs/)

---

**Author:** Saify (@saifyxpro)  
**Repository:** [saifyxpro/covid19-full-stack](https://github.com/saifyxpro/covid19-full-stack)

*Happy Deploying! 🚀*
