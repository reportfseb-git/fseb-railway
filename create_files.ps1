# create_files.ps1 - Create all deployment files for Render
Write-Host "Creating deployment files..." -ForegroundColor Cyan

# 1. railway.json (if you still want it)
@'
{
  "build": {
    "builder": "NIXPACKS"
  },
  "deploy": {
    "startCommand": "gunicorn --bind 0.0.0.0:$PORT app_azure_fixed:app"
  }
}
'@ | Out-File -FilePath "railway.json" -Encoding UTF8
Write-Host "✅ Created: railway.json" -ForegroundColor Green

# 2. render.yaml (for Render.com - RECOMMENDED)
@'
services:
  - type: web
    name: fseb-flask
    env: python
    buildCommand: pip install -r requirements.txt
    startCommand: gunicorn app_azure_fixed:app
    envVars:
      - key: AZURE_PASSWORD
        sync: false
      - key: AZURE_SERVER
        value: fseb.database.windows.net
      - key: AZURE_DATABASE
        value: fseb
      - key: AZURE_USERNAME
        value: fseb_admin
      - key: SECRET_KEY
        generateValue: true
    plan: free
'@ | Out-File -FilePath "render.yaml" -Encoding UTF8
Write-Host "✅ Created: render.yaml" -ForegroundColor Green

# 3. requirements.txt
@'
Flask==2.3.3
pymssql==2.3.11
gunicorn==21.2.0
python-dotenv==1.0.0
'@ | Out-File -FilePath "requirements.txt" -Encoding UTF8
Write-Host "✅ Created: requirements.txt" -ForegroundColor Green

# 4. runtime.txt
@'
python-3.10.0
'@ | Out-File -FilePath "runtime.txt" -Encoding UTF8
Write-Host "✅ Created: runtime.txt" -ForegroundColor Green

# 5. Procfile
@'
web: gunicorn --bind 0.0.0.0:$PORT app_azure_fixed:app
'@ | Out-File -FilePath "Procfile" -Encoding UTF8
Write-Host "✅ Created: Procfile" -ForegroundColor Green

# 6. .gitignore
@'
__pycache__/
*.pyc
.env
venv/
*.log
.DS_Store
'@ | Out-File -FilePath ".gitignore" -Encoding UTF8
Write-Host "✅ Created: .gitignore" -ForegroundColor Green

Write-Host "`n🎉 All files created successfully!" -ForegroundColor Cyan
Write-Host "Next: git add . && git commit -m 'Add deployment files' && git push" -ForegroundColor Yellow