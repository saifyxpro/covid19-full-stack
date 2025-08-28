@echo off
setlocal EnableDelayedExpansion

echo.
echo ^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=
echo    COVID-19 Application Deployment Script for Windows
echo    Created by Saify (@saifyxpro)
echo    Repository: https://github.com/saifyxpro/covid19-full-stack
echo ^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=
echo.

REM Check Node.js
echo [STEP] Checking Node.js installation...
node --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Node.js is not installed. Please install Node.js v16 or higher.
    echo Download from: https://nodejs.org/
    pause
    exit /b 1
) else (
    for /f "tokens=*" %%i in ('node --version') do set NODE_VERSION=%%i
    echo [INFO] Node.js is installed: !NODE_VERSION!
)

REM Check MongoDB
echo [STEP] Checking MongoDB...
mongo --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    mongosh --version >nul 2>&1
    if %ERRORLEVEL% NEQ 0 (
        echo [WARNING] MongoDB is not installed or not in PATH
        echo Please install MongoDB from: https://www.mongodb.com/try/download/community
    ) else (
        echo [INFO] MongoDB shell (mongosh) is available
    )
) else (
    echo [INFO] MongoDB shell (mongo) is available
)

echo.
echo [STEP] Setting up server...
cd server

REM Check server .env
if not exist ".env" (
    echo [WARNING] Server .env file not found. Creating from template...
    copy .env.example .env >nul
    echo [INFO] Please edit server/.env with your configuration
)

REM Install server dependencies
echo [INFO] Installing server dependencies...
call npm install
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to install server dependencies
    pause
    exit /b 1
)

REM Create directories
if not exist "logs" mkdir logs
if not exist "temp" mkdir temp

echo [INFO] Server setup completed!
cd ..

echo.
echo [STEP] Setting up client...
cd client

REM Check client .env
if not exist ".env" (
    echo [WARNING] Client .env file not found. Creating from template...
    copy .env.example .env >nul
    echo [INFO] Please edit client/.env with your Mapbox token
)

REM Install client dependencies
echo [INFO] Installing client dependencies...
call npm install
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to install client dependencies
    pause
    exit /b 1
)

echo [INFO] Client setup completed!
cd ..

echo.
echo [STEP] Importing sample data...
if exist "dummy_statistics.json" (
    echo [INFO] Found sample data file
    mongoimport --uri "mongodb://127.0.0.1:27017/covid-19" --collection covid_statistics --file dummy_statistics.json --drop >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo [INFO] Sample data imported successfully!
    ) else (
        echo [WARNING] Failed to import sample data. You can import it manually later:
        echo mongoimport --uri "mongodb://127.0.0.1:27017/covid-19" --collection covid_statistics --file dummy_statistics.json
    )
) else (
    echo [WARNING] Sample data file (dummy_statistics.json) not found
)

echo.
echo ^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=
echo    Deployment Complete! 🎉
echo    COVID-19 Full Stack Application by Saify (@saifyxpro)
echo ^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=
echo.
echo Next steps:
echo.
echo 1. Configure environment variables:
echo    - Edit server\.env (MongoDB URI, etc.)
echo    - Edit client\.env (Mapbox token from https://mapbox.com)
echo.
echo 2. Start the application:
echo    - Terminal 1: cd server ^&^& npm run dev
echo    - Terminal 2: cd client ^&^& npm start
echo.
echo 3. Access the application:
echo    - Client: http://localhost:3000
echo    - Server API: http://localhost:9000/api
echo    - Health Check: http://localhost:9000/health
echo.
echo 4. For production deployment:
echo    - Docker: docker-compose up -d
echo    - PM2: Check README.md for instructions
echo.
echo 5. Get help:
echo    - Documentation: https://github.com/saifyxpro/covid19-full-stack
echo    - Issues: https://github.com/saifyxpro/covid19-full-stack/issues
echo    - Contact: @saifyxpro
echo.
echo [INFO] Deployment script completed successfully!
echo Made with ❤️ by Saify (@saifyxpro)
echo.
pause

REM Check Node.js
echo [STEP] Checking Node.js installation...
node --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Node.js is not installed. Please install Node.js v16 or higher.
    echo Download from: https://nodejs.org/
    pause
    exit /b 1
) else (
    for /f "tokens=*" %%i in ('node --version') do set NODE_VERSION=%%i
    echo [INFO] Node.js is installed: !NODE_VERSION!
)

REM Check MongoDB
echo [STEP] Checking MongoDB...
mongo --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    mongosh --version >nul 2>&1
    if %ERRORLEVEL% NEQ 0 (
        echo [WARNING] MongoDB is not installed or not in PATH
        echo Please install MongoDB from: https://www.mongodb.com/try/download/community
    ) else (
        echo [INFO] MongoDB shell (mongosh) is available
    )
) else (
    echo [INFO] MongoDB shell (mongo) is available
)

echo.
echo [STEP] Setting up server...
cd server

REM Check server .env
if not exist ".env" (
    echo [WARNING] Server .env file not found. Creating from template...
    copy .env.example .env >nul
    echo [INFO] Please edit server/.env with your configuration
)

REM Install server dependencies
echo [INFO] Installing server dependencies...
call npm install
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to install server dependencies
    pause
    exit /b 1
)

REM Create directories
if not exist "logs" mkdir logs
if not exist "temp" mkdir temp

echo [INFO] Server setup completed!
cd ..

echo.
echo [STEP] Setting up client...
cd client

REM Check client .env
if not exist ".env" (
    echo [WARNING] Client .env file not found. Creating from template...
    copy .env.example .env >nul
    echo [INFO] Please edit client/.env with your Mapbox token
)

REM Install client dependencies
echo [INFO] Installing client dependencies...
call npm install
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to install client dependencies
    pause
    exit /b 1
)

echo [INFO] Client setup completed!
cd ..

echo.
echo [STEP] Importing sample data...
if exist "dummy_statistics.json" (
    echo [INFO] Found sample data file
    mongoimport --uri "mongodb://127.0.0.1:27017/covid-19" --collection covid_statistics --file dummy_statistics.json --drop >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo [INFO] Sample data imported successfully!
    ) else (
        echo [WARNING] Failed to import sample data. You can import it manually later:
        echo mongoimport --uri "mongodb://127.0.0.1:27017/covid-19" --collection covid_statistics --file dummy_statistics.json
    )
) else (
    echo [WARNING] Sample data file (dummy_statistics.json) not found
)

echo.
echo ^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=
echo    Deployment Complete! 🎉
echo ^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=
echo.
echo Next steps:
echo.
echo 1. Configure environment variables:
echo    - Edit server\.env (MongoDB URI, etc.)
echo    - Edit client\.env (Mapbox token)
echo.
echo 2. Start the application:
echo    - Terminal 1: cd server ^&^& npm run dev
echo    - Terminal 2: cd client ^&^& npm start
echo.
echo 3. Access the application:
echo    - Client: http://localhost:3000
echo    - Server: http://localhost:9000
echo    - Health: http://localhost:9000/health
echo.
echo 4. For Docker deployment:
echo    docker-compose up -d
echo.
echo [INFO] Deployment script completed successfully!
echo.
pause
