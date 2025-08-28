#!/bin/bash

# COVID-19 Application Deployment Script
# Created by Saify (@saifyxpro)
# Repository: https://github.com/saifyxpro/covid19-full-stack

echo "🚀 Starting COVID-19 Application Deployment..."
echo "Created by Saify (@saifyxpro)"
echo "Repository: https://github.com/saifyxpro/covid19-full-stack"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

print_success() {
    echo -e "${PURPLE}[SUCCESS]${NC} $1"
}

# Check if Node.js is installed
check_node() {
    if command -v node >/dev/null 2>&1; then
        NODE_VERSION=$(node --version)
        print_status "Node.js is installed: $NODE_VERSION"
        
        # Check if version is >= 16
        NODE_MAJOR_VERSION=$(echo $NODE_VERSION | cut -d'.' -f1 | sed 's/v//')
        if [ "$NODE_MAJOR_VERSION" -ge 16 ]; then
            print_status "Node.js version is compatible (>= v16)"
        else
            print_error "Node.js version must be >= 16. Current: $NODE_VERSION"
            echo "Please update Node.js from: https://nodejs.org/"
            exit 1
        fi
    else
        print_error "Node.js is not installed. Please install Node.js v16 or higher."
        echo "Download from: https://nodejs.org/"
        exit 1
    fi
}

# Check if MongoDB is running
check_mongodb() {
    if command -v mongosh >/dev/null 2>&1; then
        print_status "MongoDB shell (mongosh) is available"
        
        # Try to connect to MongoDB
        if mongosh --eval "db.runCommand('ping')" --quiet >/dev/null 2>&1; then
            print_status "MongoDB is running and accessible"
        else
            print_warning "MongoDB is not running. Please start MongoDB service."
            echo "  Windows: Start MongoDB service from Services or run 'mongod'"
            echo "  macOS: brew services start mongodb-community"
            echo "  Linux: sudo systemctl start mongod"
        fi
    elif command -v mongo >/dev/null 2>&1; then
        print_status "MongoDB shell (legacy mongo) is available"
        
        if mongo --eval "db.runCommand('ping')" --quiet >/dev/null 2>&1; then
            print_status "MongoDB is running and accessible"
        else
            print_warning "MongoDB is not running. Please start MongoDB service."
        fi
    else
        print_error "MongoDB is not installed. Please install MongoDB."
        echo "Download from: https://www.mongodb.com/try/download/community"
        exit 1
    fi
}

# Setup server
setup_server() {
    print_header "Setting up server..."
    
    cd server
    
    # Check if .env exists
    if [ ! -f ".env" ]; then
        print_warning ".env file not found. Creating from template..."
        cp .env.example .env
        print_status "Please edit server/.env with your configuration"
    fi
    
    # Install dependencies
    print_status "Installing server dependencies..."
    npm install
    
    if [ $? -eq 0 ]; then
        print_success "Server dependencies installed successfully!"
    else
        print_error "Failed to install server dependencies"
        exit 1
    fi
    
    # Create directories
    mkdir -p logs temp
    
    print_success "Server setup completed!"
    cd ..
}

# Setup client
setup_client() {
    print_header "Setting up client..."
    
    cd client
    
    # Check if .env exists
    if [ ! -f ".env" ]; then
        print_warning ".env file not found. Creating from template..."
        cp .env.example .env
        print_status "Please edit client/.env with your Mapbox token"
        print_status "Get free token from: https://account.mapbox.com/"
    fi
    
    # Install dependencies
    print_status "Installing client dependencies..."
    npm install
    
    if [ $? -eq 0 ]; then
        print_success "Client dependencies installed successfully!"
    else
        print_error "Failed to install client dependencies"
        exit 1
    fi
    
    print_success "Client setup completed!"
    cd ..
}

# Import sample data
import_sample_data() {
    print_header "Importing sample data..."
    
    if [ -f "dummy_statistics.json" ]; then
        print_status "Found sample data file"
        
        # Try to import data
        if command -v mongoimport >/dev/null 2>&1; then
            print_status "Importing sample data to MongoDB..."
            mongoimport --uri "mongodb://127.0.0.1:27017/covid-19" --collection covid_statistics --file dummy_statistics.json --drop
            
            if [ $? -eq 0 ]; then
                print_success "Sample data imported successfully!"
            else
                print_warning "Failed to import sample data. You can import it manually later."
                echo "Command: mongoimport --uri 'mongodb://127.0.0.1:27017/covid-19' --collection covid_statistics --file dummy_statistics.json"
            fi
        else
            print_warning "mongoimport not found. Please import sample data manually:"
            echo "  mongoimport --uri 'mongodb://127.0.0.1:27017/covid-19' --collection covid_statistics --file dummy_statistics.json"
        fi
    else
        print_warning "Sample data file (dummy_statistics.json) not found"
    fi
}

# Main deployment function
main() {
    echo ""
    echo "=================================================="
    echo "   COVID-19 Full Stack Application Setup"
    echo "   Created by Saify (@saifyxpro)"
    echo "=================================================="
    echo ""
    
    # Checks
    check_node
    check_mongodb
    
    echo ""
    
    # Setup
    setup_server
    echo ""
    setup_client
    echo ""
    
    # Data import
    import_sample_data
    echo ""
    
    # Final instructions
    echo "=================================================="
    echo "   Deployment Complete! 🎉"
    echo "=================================================="
    echo ""
    echo "Next steps:"
    echo ""
    echo "1. Configure environment variables:"
    echo "   - Edit server/.env (MongoDB URI, etc.)"
    echo "   - Edit client/.env (Get Mapbox token from https://mapbox.com)"
    echo ""
    echo "2. Start the application:"
    echo "   Terminal 1: cd server && npm run dev"
    echo "   Terminal 2: cd client && npm start"
    echo ""
    echo "3. Access the application:"
    echo "   - Client: http://localhost:3000"
    echo "   - Server API: http://localhost:9000/api"
    echo "   - Health Check: http://localhost:9000/health"
    echo ""
    echo "4. Production deployment:"
    echo "   - Docker: docker-compose up -d"
    echo "   - PM2: Check README.md for instructions"
    echo ""
    echo "5. Get help and documentation:"
    echo "   - GitHub: https://github.com/saifyxpro/covid19-full-stack"
    echo "   - Issues: https://github.com/saifyxpro/covid19-full-stack/issues"
    echo "   - Contact: @saifyxpro on all platforms"
    echo ""
    
    print_success "Deployment script completed successfully!"
    echo ""
    echo "Made with ❤️ by Saify (@saifyxpro)"
    echo "⭐ Star the repo if you find it helpful!"
}

# Run main function
main

# Check if Node.js is installed
check_node() {
    if command -v node >/dev/null 2>&1; then
        NODE_VERSION=$(node --version)
        print_status "Node.js is installed: $NODE_VERSION"
        
        # Check if version is >= 16
        NODE_MAJOR_VERSION=$(echo $NODE_VERSION | cut -d'.' -f1 | sed 's/v//')
        if [ "$NODE_MAJOR_VERSION" -ge 16 ]; then
            print_status "Node.js version is compatible (>= v16)"
        else
            print_error "Node.js version must be >= 16. Current: $NODE_VERSION"
            exit 1
        fi
    else
        print_error "Node.js is not installed. Please install Node.js v16 or higher."
        exit 1
    fi
}

# Check if MongoDB is running
check_mongodb() {
    if command -v mongosh >/dev/null 2>&1; then
        print_status "MongoDB shell (mongosh) is available"
        
        # Try to connect to MongoDB
        if mongosh --eval "db.runCommand('ping')" --quiet >/dev/null 2>&1; then
            print_status "MongoDB is running and accessible"
        else
            print_warning "MongoDB is not running. Please start MongoDB service."
            echo "  Windows: Start MongoDB service from Services or run 'mongod'"
            echo "  macOS: brew services start mongodb-community"
            echo "  Linux: sudo systemctl start mongod"
        fi
    elif command -v mongo >/dev/null 2>&1; then
        print_status "MongoDB shell (legacy mongo) is available"
        
        if mongo --eval "db.runCommand('ping')" --quiet >/dev/null 2>&1; then
            print_status "MongoDB is running and accessible"
        else
            print_warning "MongoDB is not running. Please start MongoDB service."
        fi
    else
        print_error "MongoDB is not installed. Please install MongoDB."
        exit 1
    fi
}

# Setup server
setup_server() {
    print_header "Setting up server..."
    
    cd server
    
    # Check if .env exists
    if [ ! -f ".env" ]; then
        print_warning ".env file not found. Creating from template..."
        cp .env.example .env
        print_status "Please edit server/.env with your configuration"
    fi
    
    # Install dependencies
    print_status "Installing server dependencies..."
    npm install
    
    # Create directories
    mkdir -p logs temp
    
    print_status "Server setup completed!"
    cd ..
}

# Setup client
setup_client() {
    print_header "Setting up client..."
    
    cd client
    
    # Check if .env exists
    if [ ! -f ".env" ]; then
        print_warning ".env file not found. Creating from template..."
        cp .env.example .env
        print_status "Please edit client/.env with your Mapbox token"
    fi
    
    # Install dependencies
    print_status "Installing client dependencies..."
    npm install
    
    print_status "Client setup completed!"
    cd ..
}

# Import sample data
import_sample_data() {
    print_header "Importing sample data..."
    
    if [ -f "dummy_statistics.json" ]; then
        print_status "Found sample data file"
        
        # Try to import data
        if command -v mongoimport >/dev/null 2>&1; then
            print_status "Importing sample data to MongoDB..."
            mongoimport --uri "mongodb://127.0.0.1:27017/covid-19" --collection covid_statistics --file dummy_statistics.json --drop
            
            if [ $? -eq 0 ]; then
                print_status "Sample data imported successfully!"
            else
                print_warning "Failed to import sample data. You can import it manually later."
            fi
        else
            print_warning "mongoimport not found. Please import sample data manually:"
            echo "  mongoimport --uri 'mongodb://127.0.0.1:27017/covid-19' --collection covid_statistics --file dummy_statistics.json"
        fi
    else
        print_warning "Sample data file (dummy_statistics.json) not found"
    fi
}

# Main deployment function
main() {
    print_header "COVID-19 Application Deployment"
    echo ""
    
    # Checks
    check_node
    check_mongodb
    
    echo ""
    
    # Setup
    setup_server
    echo ""
    setup_client
    echo ""
    
    # Data import
    import_sample_data
    echo ""
    
    # Final instructions
    print_header "Deployment Complete! 🎉"
    echo ""
    echo "Next steps:"
    echo "1. Configure environment variables:"
    echo "   - Edit server/.env (MongoDB URI, etc.)"
    echo "   - Edit client/.env (Mapbox token)"
    echo ""
    echo "2. Start the application:"
    echo "   Terminal 1: cd server && npm run dev"
    echo "   Terminal 2: cd client && npm start"
    echo ""
    echo "3. Access the application:"
    echo "   - Client: http://localhost:3000"
    echo "   - Server: http://localhost:9000"
    echo "   - Health: http://localhost:9000/health"
    echo ""
    echo "4. For Docker deployment:"
    echo "   docker-compose up -d"
    echo ""
    
    print_status "Deployment script completed successfully!"
}

# Run main function
main
