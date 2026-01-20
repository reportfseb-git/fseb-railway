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
        print(f" {imp}")
    except ImportError:
        print(f" {imp} - MISSING")
        
print("\nIf any show , add to requirements.txt")
