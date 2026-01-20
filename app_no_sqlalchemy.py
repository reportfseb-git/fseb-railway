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
