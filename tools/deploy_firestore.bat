@echo off
REM Firestore Rules Deployment Script for Windows
REM Run this script to deploy Firestore rules and indexes

echo ========================================
echo  Firestore Rules Deployment
echo ========================================
echo.

REM Check if Firebase CLI is installed
where firebase >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Firebase CLI is not installed
    echo.
    echo Please install it first:
    echo npm install -g firebase-tools
    echo.
    pause
    exit /b 1
)

echo Firebase CLI found!
echo.

REM Login check
echo Checking Firebase login status...
firebase login:list >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo You need to login to Firebase first
    echo.
    firebase login
)

echo.
echo ========================================
echo  Deploying Firestore Rules
echo ========================================
echo.

firebase deploy --only firestore:rules

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Failed to deploy rules
    echo.
    pause
    exit /b 1
)

echo.
echo ✅ Rules deployed successfully!
echo.

echo ========================================
echo  Deploying Firestore Indexes
echo ========================================
echo.

firebase deploy --only firestore:indexes

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Failed to deploy indexes
    echo Note: Some indexes may need to be created manually
    echo.
    pause
    exit /b 1
)

echo.
echo ✅ Indexes deployed successfully!
echo.

echo ========================================
echo  Deployment Complete!
echo ========================================
echo.
echo Your Firestore rules and indexes are now live.
echo.
echo Next steps:
echo 1. Verify rules in Firebase Console
echo 2. Test your app
echo 3. Check for any permission errors
echo.

pause

