## 💻 Development Setup

Thank you for your interest in contributing to the COVID-19 Full Stack Application! This guide will help you set up your development environment.

### 📋 Prerequisites

Before you begin, ensure you have the following installed:

- **Node.js** (v16.0.0 or higher) - [Download here](https://nodejs.org/)
- **npm** (v7.0.0 or higher) - Comes with Node.js
- **MongoDB** (v4.4.0 or higher) - [Download here](https://www.mongodb.com/try/download/community)
- **Git** - [Download here](https://git-scm.com/downloads)
- **Docker** (optional, for containerized development) - [Download here](https://www.docker.com/products/docker-desktop)

### 🔧 Quick Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/saifyxpro/covid19-full-stack.git
   cd covid19-full-stack
   ```

2. **Run the setup script**
   ```bash
   # Windows
   .\deploy.bat

   # macOS/Linux
   ./deploy.sh
   ```

### 📦 Manual Setup

If you prefer to set up manually or the script doesn't work:

#### Server Setup

1. **Navigate to server directory**
   ```bash
   cd server
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env
   ```
   Edit `.env` with your configuration:
   ```env
   PORT=5000
   MONGODB_URI=mongodb://localhost:27017/covid19
   NODE_ENV=development
   API_RATE_LIMIT=100
   CORS_ORIGIN=http://localhost:3000
   ```

4. **Start the server**
   ```bash
   npm run dev
   ```

#### Client Setup

1. **Open a new terminal and navigate to client directory**
   ```bash
   cd client
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env
   ```
   Edit `.env` with your configuration:
   ```env
   REACT_APP_API_URL=http://localhost:5000
   REACT_APP_MAP_API_KEY=your_map_api_key_here
   ```

4. **Start the client**
   ```bash
   npm start
   ```

### 🐳 Docker Development

For containerized development:

1. **Start all services**
   ```bash
   docker-compose up --build
   ```

2. **Access the application**
   - Client: http://localhost:3000
   - Server: http://localhost:5000
   - MongoDB: mongodb://localhost:27017

### 🧪 Running Tests

#### Server Tests
```bash
cd server
npm test                 # Run all tests
npm run test:watch      # Run tests in watch mode
npm run test:coverage   # Run tests with coverage
```

#### Client Tests
```bash
cd client
npm test                # Run all tests
npm run test:coverage   # Run tests with coverage
```

### 🔍 Code Quality

#### Linting
```bash
# Server
cd server && npm run lint
cd server && npm run lint:fix  # Auto-fix issues

# Client
cd client && npm run lint
cd client && npm run lint:fix  # Auto-fix issues
```

#### Security Audit
```bash
# Check for vulnerabilities
cd server && npm audit
cd client && npm audit

# Auto-fix vulnerabilities
cd server && npm audit fix
cd client && npm audit fix
```

### 📚 Development Scripts

#### Server Scripts
```bash
npm start              # Start production server
npm run dev           # Start development server with nodemon
npm run build         # Build for production
npm test              # Run tests
npm run lint          # Run ESLint
npm run format        # Format code with Prettier
```

#### Client Scripts
```bash
npm start             # Start development server
npm run build         # Build for production
npm test              # Run tests
npm run eject         # Eject from Create React App (irreversible)
npm run lint          # Run ESLint
npm run format        # Format code with Prettier
```

### 🌐 Environment Variables

#### Server Environment Variables
| Variable | Description | Default |
|----------|-------------|---------|
| `PORT` | Server port | `5000` |
| `MONGODB_URI` | MongoDB connection string | `mongodb://localhost:27017/covid19` |
| `NODE_ENV` | Environment mode | `development` |
| `API_RATE_LIMIT` | Rate limit per window | `100` |
| `CORS_ORIGIN` | CORS allowed origin | `http://localhost:3000` |

#### Client Environment Variables
| Variable | Description | Default |
|----------|-------------|---------|
| `REACT_APP_API_URL` | Backend API URL | `http://localhost:5000` |
| `REACT_APP_MAP_API_KEY` | Map service API key | Required for maps |

### 🚀 Deployment

#### Development Deployment
```bash
# Build both client and server
npm run build:all

# Start production server
npm run start:prod
```

#### Production Deployment
See [DEPLOYMENT.md](./DEPLOYMENT.md) for detailed production deployment instructions.

### 🐛 Troubleshooting

#### Common Issues

1. **Port already in use**
   ```bash
   # Kill process on port
   npx kill-port 3000  # for client
   npx kill-port 5000  # for server
   ```

2. **MongoDB connection error**
   - Ensure MongoDB is running
   - Check connection string in `.env`
   - Verify MongoDB service status

3. **Module not found errors**
   ```bash
   # Clear npm cache and reinstall
   npm cache clean --force
   rm -rf node_modules package-lock.json
   npm install
   ```

4. **Build errors**
   ```bash
   # Clear build cache
   npm run clean
   npm run build
   ```

#### Development Tips

- **Hot Reload**: Both client and server support hot reloading
- **Debug Mode**: Set `DEBUG=*` for verbose logging
- **Database GUI**: Use MongoDB Compass for database visualization
- **API Testing**: Use Postman collection (see `docs/api/`)

### 📖 Additional Resources

- [Contributing Guidelines](./CONTRIBUTING.md)
- [API Documentation](./docs/API.md)
- [Deployment Guide](./DEPLOYMENT.md)
- [Security Policy](./SECURITY.md)
- [Changelog](./CHANGELOG.md)

### 💬 Getting Help

If you encounter any issues:

1. Check the [Issues](https://github.com/saifyxpro/covid19-full-stack/issues) page
2. Search existing discussions
3. Create a new issue with detailed information
4. Join our community discussions

### 👥 Community

- **Maintainer**: Saify (@saifyxpro)
- **Repository**: [saifyxpro/covid19-full-stack](https://github.com/saifyxpro/covid19-full-stack)
- **Issues**: [Report bugs and request features](https://github.com/saifyxpro/covid19-full-stack/issues)

---

**Happy Coding! 🎉**

*Thank you for contributing to the COVID-19 Full Stack Application. Together, we can build better tools for public health awareness.*
