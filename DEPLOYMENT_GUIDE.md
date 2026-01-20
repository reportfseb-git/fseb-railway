# RAILWAY DEPLOYMENT GUIDE
# ========================

## 1. PREPARE GITHUB
1. Go to https://github.com
2. Create new repository: fseb-railway
3. DO NOT initialize with README

## 2. UPLOAD TO GITHUB
Run these commands:
```bash
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/reportfseb-git/fseb-railway.git
git push -u origin main

3. DEPLOY ON RAILWAY
Go to https://railway.app

Sign up/login

Click "New Project"

Select "Deploy from GitHub repo"

Connect GitHub account

Select your repository: fseb-railway

4. SET ENVIRONMENT VARIABLES
After deployment, in Railway dashboard:

Go to your project â†’ Variables tab

Add these variables:

AZURE_PASSWORD = Welcome1

AZURE_SERVER = fseb.database.windows.net

AZURE_DATABASE = fseb

AZURE_USERNAME = fseb_admin

SECRET_KEY = railway-secret-key

5. TEST YOUR APP
Your app will be at: https://[project-name].up.railway.app

Test endpoints:

/ - Main dashboard

/api/health - Health check

/api/test - Azure connection test

/debug - Environment info

TROUBLESHOOTING
Check logs: In Railway dashboard â†’ Logs tab

If Azure connection fails: Check firewall allows Railway IPs

If app crashes: Check environment variables are set
