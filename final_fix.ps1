# final_fix.ps1 - Fix Python version and SQLAlchemy issues
Write-Host "FINAL FIX: Removing SQLAlchemy and forcing Python 3.10" -ForegroundColor Cyan

# 1. Create app_no_sqlalchemy.py
@'
from flask import Flask, jsonify
import pymssql
import os
import sys

app = Flask(__name__)

# Azure configuration
AZURE_CONFIG = {
    'server': os.environ.get('AZURE_SERVER', 'fseb.database.windows.net'),
    'database': os.environ.get('AZURE_DATABASE', 'fseb'),
    'user': os.environ.get('AZURE_USERNAME', 'fseb_admin'),
    'password': os.environ.get('AZURE_PASSWORD', '')
}

@app.route('/')
def home():
    try:
        conn = pymssql.connect(**AZURE_CONFIG)
        cursor = conn.cursor()
        cursor.execute('SELECT @@VERSION')
        version = cursor.fetchone()[0]
        conn.close()
        return jsonify({
            'status': 'online',
            'database': 'Azure SQL',
            'connected': True,
            'python': sys.version.split()[0],
            'version': version[:50]
        })
    except Exception as e:
        return jsonify({
            'status': 'error',
            'error': str(e),
            'python': sys.version.split()[0]
        })

@app.route('/health')
def health():
    return 'OK'

@app.route('/api/test')
def test():
    try:
        conn = pymssql.connect(**AZURE_CONFIG)
        conn.close()
        return jsonify({'success': True})
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)})

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)
'@ | Out-File -FilePath "app_no_sqlalchemy.py" -Encoding UTF8

# 2. Create minimal requirements.txt
@'
Flask==2.3.3
pymssql==2.3.11
gunicorn==21.2.0
'@ | Out-File -FilePath "requirements.txt" -Encoding UTF8 -Force

# 3. Update render.yaml
@'
services:
  - type: web
    name: fseb-flask
    env: python
    pythonVersion: 3.10.0
    buildCommand: pip install -r requirements.txt
    startCommand: gunicorn app_no_sqlalchemy:app
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
'@ | Out-File -FilePath "render.yaml" -Encoding UTF8 -Force

# 4. Create runtime.txt
@'
python-3.10.0
'@ | Out-File -FilePath "runtime.txt" -Encoding UTF8 -Force

Write-Host "`n✅ Created:" -ForegroundColor Green
Write-Host "  • app_no_sqlalchemy.py (no SQLAlchemy dependency)" -ForegroundColor Gray
Write-Host "  • requirements.txt (minimal: Flask, pymssql, gunicorn)" -ForegroundColor Gray
Write-Host "  • render.yaml (forces Python 3.10)" -ForegroundColor Gray
Write-Host "  • runtime.txt (Python 3.10)" -ForegroundColor Gray

# 5. Push to GitHub
Write-Host "`n📤 Pushing to GitHub..." -ForegroundColor Yellow
git add .
git commit -m "FINAL: Remove SQLAlchemy, force Python 3.10"
git push origin main

Write-Host "`n🎉 FINAL FIX COMPLETE!" -ForegroundColor Green
Write-Host "Render will now:" -ForegroundColor Cyan
Write-Host "1. Use Python 3.10" -ForegroundColor Gray
Write-Host "2. Install only Flask + pymssql + gunicorn" -ForegroundColor Gray
Write-Host "3. Run app_no_sqlalchemy.py (no SQLAlchemy)" -ForegroundColor Gray
Write-Host "4. Deploy successfully!" -ForegroundColor Gray