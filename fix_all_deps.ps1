# fix_all_deps.ps1 - Fix ALL missing dependencies for Render
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   FIXING ALL MISSING DEPENDENCIES      " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# 1. Create complete requirements.txt
Write-Host "`n1. Creating complete requirements.txt..." -ForegroundColor Yellow
@'
Flask==2.3.3
pymssql==2.3.11
Flask-SQLAlchemy==3.0.5
Flask-CORS==4.0.0
python-dotenv==1.0.0
gunicorn==21.2.0
SQLAlchemy==2.0.19
'@ | Out-File -FilePath "requirements.txt" -Encoding UTF8 -Force
Write-Host "   ✅ Created with ALL required packages" -ForegroundColor Green

# 2. Check what imports your app actually uses
Write-Host "`n2. Scanning app_azure_fixed.py for imports..." -ForegroundColor Yellow
if (Test-Path "app_azure_fixed.py") {
    $imports = @()
    $content = Get-Content "app_azure_fixed.py" -Encoding UTF8
    
    foreach ($line in $content) {
        if ($line -match "^\s*(import|from)\s+") {
            $imports += $line.Trim()
        }
    }
    
    Write-Host "   Found imports:" -ForegroundColor Gray
    $imports | ForEach-Object { Write-Host "     - $_" -ForegroundColor Gray }
}

# 3. Create a simple test to verify locally (optional)
Write-Host "`n3. Creating dependency test..." -ForegroundColor Yellow
@'
# test_imports.py - Test all imports locally
imports_to_test = [
    "flask",
    "pymssql", 
    "flask_sqlalchemy",
    "flask_cors",
    "dotenv",
    "sqlalchemy"
]

print("Testing imports...")
for imp in imports_to_test:
    try:
        __import__(imp)
        print(f"✅ {imp}")
    except ImportError:
        print(f"❌ {imp} - MISSING")
        
print("\nIf any show ❌, add to requirements.txt")
'@ | Out-File -FilePath "test_imports.py" -Encoding UTF8
Write-Host "   ✅ Created: test_imports.py" -ForegroundColor Green

# 4. Update runtime.txt for Python 3.10 (more stable)
Write-Host "`n4. Setting Python version to 3.10..." -ForegroundColor Yellow
@'
python-3.10.0
'@ | Out-File -FilePath "runtime.txt" -Encoding UTF8 -Force
Write-Host "   ✅ Python 3.10 set (more stable)" -ForegroundColor Green

# 5. Update render.yaml if needed
Write-Host "`n5. Updating render.yaml..." -ForegroundColor Yellow
if (Test-Path "render.yaml") {
    $renderYaml = Get-Content "render.yaml" -Encoding UTF8 -Raw
    if ($renderYaml -notmatch "python-version") {
        $renderYaml = $renderYaml -replace "env: python", "env: python`n    pythonVersion: 3.10.0"
        $renderYaml | Out-File "render.yaml" -Encoding UTF8
        Write-Host "   ✅ Added pythonVersion to render.yaml" -ForegroundColor Green
    }
}

# 6. Push to GitHub
Write-Host "`n6. Pushing fixes to GitHub..." -ForegroundColor Yellow
git add .
git commit -m "Fix: Add ALL missing dependencies (flask_sqlalchemy, etc.)"
git push origin main

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "   ✅ ALL FIXES PUSHED TO GITHUB!        " -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan

Write-Host "`n📊 Render will now:" -ForegroundColor Yellow
Write-Host "1. Auto-redeploy your app" -ForegroundColor Gray
Write-Host "2. Install ALL required packages" -ForegroundColor Gray
Write-Host "3. Start gunicorn successfully" -ForegroundColor Gray

Write-Host "`n⏳ Wait 2-3 minutes for deployment..." -ForegroundColor Cyan
Write-Host "Check: https://dashboard.render.com" -ForegroundColor White