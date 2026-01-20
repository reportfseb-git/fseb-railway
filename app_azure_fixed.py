# app_azure_fixed.py - SIMPLE WORKING VERSION FOR RENDER
from flask import Flask, jsonify
import pymssql
import os
import sys

print("🚀 Starting Azure SQL Flask app on Render...")
print(f"Python: {sys.version}")
print(f"Port: {os.environ.get('PORT', '5000')}")

app = Flask(__name__)

# Azure configuration
AZURE_CONFIG = {
    'server': os.environ.get('AZURE_SERVER', 'fseb.database.windows.net'),
    'database': os.environ.get('AZURE_DATABASE', 'fseb'),
    'user': os.environ.get('AZURE_USERNAME', 'fseb_admin'),
    'password': os.environ.get('AZURE_PASSWORD', '')
}

print(f"Azure Server: {AZURE_CONFIG['server']}")
print(f"Azure Database: {AZURE_CONFIG['database']}")

@app.route('/')
def home():
    return jsonify({
        'app': 'Azure SQL Flask',
        'status': 'online',
        'hosting': 'Render.com',
        'python': sys.version.split()[0],
        'endpoints': {
            'home': '/',
            'health': '/health',
            'test': '/test',
            'tables': '/tables'
        }
    })

@app.route('/health')
def health():
    return jsonify({
        'status': 'healthy',
        'timestamp': '2024-01-20',
        'service': 'Azure SQL Flask API'
    })

@app.route('/test')
def test_connection():
    """Test Azure SQL connection"""
    try:
        conn = pymssql.connect(**AZURE_CONFIG)
        cursor = conn.cursor()
        cursor.execute('SELECT @@VERSION, DB_NAME()')
        version, db_name = cursor.fetchone()
        conn.close()
        
        return jsonify({
            'success': True,
            'message': '✅ Connected to Azure SQL',
            'database': db_name,
            'version': version[:80],
            'server': AZURE_CONFIG['server']
        })
    except Exception as e:
        return jsonify({
            'success': False,
            'message': '❌ Azure connection failed',
            'error': str(e),
            'help': 'Check AZURE_PASSWORD environment variable and firewall rules'
        })

@app.route('/tables')
def list_tables():
    """List all tables in database"""
    try:
        conn = pymssql.connect(**AZURE_CONFIG)
        cursor = conn.cursor()
        cursor.execute("""
            SELECT TABLE_SCHEMA, TABLE_NAME
            FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_TYPE = 'BASE TABLE'
            ORDER BY TABLE_SCHEMA, TABLE_NAME
        """)
        tables = [{'schema': row[0], 'name': row[1]} for row in cursor.fetchall()]
        conn.close()
        
        return jsonify({
            'success': True,
            'count': len(tables),
            'tables': tables
        })
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        })

# Render compatibility
if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    print(f"Starting Flask on port {port}...")
    app.run(host='0.0.0.0', port=port, debug=False)
