# Create deploy_railway.ps1
@'
# deploy_railway.ps1 - Complete Railway Deployment Script
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   RAILWAY DEPLOYMENT PACKAGE           " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$deployFolder = "fseb_railway_$timestamp"

Write-Host "`n📁 Creating deployment package: $deployFolder" -ForegroundColor Yellow

# Create directory
New-Item -ItemType Directory -Path $deployFolder -Force | Out-Null
cd $deployFolder

# 1. Copy essential files
$essentialFiles = @(
    "app_azure_fixed.py",
    "requirements.txt",
    "railway.json",
    "Procfile",
    "runtime.txt",
    ".gitignore"
)

Write-Host "`n1. Copying essential files..." -ForegroundColor Green
foreach ($file in $essentialFiles) {
    $source = "..\$file"
    if (Test-Path $source) {
        Copy-Item $source .
        Write-Host "   ✅ $file" -ForegroundColor Gray
    } else {
        Write-Host "   ⚠  Missing: $file" -ForegroundColor Yellow
    }
}

# 2. Create missing files if needed
Write-Host "`n2. Creating missing configuration files..." -ForegroundColor Green

# railway.json
if (-not (Test-Path "railway.json")) {
    @'
{
  "$schema": "https://railway.app/railway.schema.json",
  "build": {
    "builder": "NIXPACKS",
    "buildCommand": "pip install -r requirements.txt"
  },
  "deploy": {
    "startCommand": "gunicorn --bind 0.0.0.0:$PORT app_azure_fixed:app",
    "restartPolicyType": "ON_FAILURE",
    "restartPolicyMaxRetries": 10
  }
}
'@ | Out-File -FilePath "railway.json" -Encoding UTF8
    Write-Host "   ✅ Created: railway.json" -ForegroundColor Gray


# requirements.txt
if (-not (Test-Path "requirements.txt")) {
    @'
Flask==2.3.3
pymssql==2.3.11
Flask-SQLAlchemy==3.0.5
Flask-CORS==4.0.0
python-dotenv==1.0.0
gunicorn==21.2.0
'@ | Out-File -FilePath "requirements.txt" -Encoding UTF8
    Write-Host "   ✅ Created: requirements.txt" -ForegroundColor Gray
}

# Procfile
if (-not (Test-Path "Procfile")) {
    @'
web: gunicorn --bind 0.0.0.0:$PORT app_azure_fixed:app
'@ | Out-File -FilePath "Procfile" -Encoding UTF8
    Write-Host "   ✅ Created: Procfile" -ForegroundColor Gray
}

# runtime.txt
if (-not (Test-Path "runtime.txt")) {
    @'
python-3.10
'@ | Out-File -FilePath "runtime.txt" -Encoding UTF8
    Write-Host "   ✅ Created: runtime.txt" -ForegroundColor Gray
}

# .gitignore
if (-not (Test-Path ".gitignore")) {
    @'
__pycache__/
*.pyc
.env
venv/
*.log
.DS_Store
'@ | Out-File -FilePath ".gitignore" -Encoding UTF8
    Write-Host "   ✅ Created: .gitignore" -ForegroundColor Gray
}

# 3. Create deployment instructions
Write-Host "`n3. Creating deployment guide..." -ForegroundColor Green
@'
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
git remote add origin https://github.com/YOUR_USERNAME/fseb-railway.git
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

Go to your project → Variables tab

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
Check logs: In Railway dashboard → Logs tab

If Azure connection fails: Check firewall allows Railway IPs

If app crashes: Check environment variables are set
'@ | Out-File -FilePath "DEPLOYMENT_GUIDE.md" -Encoding UTF8
Write-Host " ✅ Created: DEPLOYMENT_GUIDE.md" -ForegroundColor Gray

#4. Initialize git
Write-Host "`n4. Initializing Git repository..." -ForegroundColor Green
@'
git init
git add .
git commit -m "Initial commit: Azure SQL Flask app for Railway"

Write-Host " ✅ Git repository initialized" -ForegroundColor Gray

Write-Host "`n📦 Deployment package created in: $deployFolder" -ForegroundColor Cyan

Write-Host "`n📋 NEXT STEPS:" -ForegroundColor Yellow
Write-Host "1. Create GitHub repository: fseb-railway" -ForegroundColor Gray
Write-Host "2. Run these commands:" -ForegroundColor Gray
Write-Host " cd $deployFolder" -ForegroundColor White
Write-Host " git remote add origin https://github.com/reportfseb-git/fseb-railway.git" -ForegroundColor White
Write-Host " git branch -M main" -ForegroundColor White
Write-Host " git push -u origin main" -ForegroundColor White
Write-Host "3. Deploy on Railway using DEPLOYMENT_GUIDE.md" -ForegroundColor Gray

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host " READY FOR RAILWAY DEPLOYMENT! " -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
'@ | Out-File -FilePath "../deploy_railway.ps1" -Encoding UTF8

Write-Host "`n✅ Created deployment script: deploy_railway.ps1" -ForegroundColor Green
Write-Host " Run it to prepare for Railway!" -ForegroundColor Gray

Set-Location ..

## **Step 5: Run the Deployment Script**

#```powershell
# Run the deployment script
#.\deploy_railway.ps1

# This will create a clean folder with all files ready